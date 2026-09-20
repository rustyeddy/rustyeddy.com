---
title: Building a Real MCP Server in Go: Giving an AI Access to an Algorithmic Trading Platform
date: 2026-09-20
draft: true
description: >
  A practical architecture guide for adding a thin MCP control plane to Trader so
  AI clients can run deterministic research and backtests through typed, auditable tools.
tags: ["Go", "MCP", "AI", "Trading Systems", "System Design"]
categories: ["Software Engineering", "Financial Software"]
slug: "building-real-mcp-server-go-trader"
---

MCP is a good boundary for exposing deterministic domain capabilities to
nondeterministic AI agents through a narrow, typed interface.

That line is the core design decision for `trader-mcp`.

The AI should decide what question to ask; Trader should remain responsible for
computing the answer.

## Why MCP?

At a practical level, MCP is a standard way for an AI client to discover and
call application tools with structured inputs and outputs.

That matters now because most teams integrating AI are starting from one of two
uncomfortable options:

- give a model ad-hoc API calls and custom glue code
- give a model shell access and hope prompts are enough guardrails

A typed MCP surface is a better boundary than both:

- schemas define what is callable
- validation rejects malformed requests early
- responses are machine-readable and auditable
- the application stays in control of domain logic

Trader is a strong real-world example because it already has:

- market-data ingestion and provenance
- reproducible backtesting
- a CLI used as an operator interface
- a Strategy Protocol / gRPC runtime boundary
- clear safety concerns for trading mutations

## Why not give the AI shell access?

The shell boundary is too broad for this problem.

```text
AI -> shell commands
```

Even with prompt constraints, shell access increases accidental coupling to:

- local filesystem layout
- process environment
- command-line quirks
- unrelated tools installed on the host

A typed MCP adapter narrows the integration surface:

```text
AI -> typed MCP tools -> Trader services
```

Benefits:

- **Safety**: no arbitrary process or filesystem execution
- **Auditability**: every tool call has a name, schema, and structured params
- **Determinism**: Trader computes the result; the model does not “recalculate” P/L
- **Loose coupling**: internal CLI plumbing stays private to Trader

## Trader architecture: existing boundaries

Before MCP, Trader already separates strategy runtime from application services.

```text
strategies -> SDK / Strategy Protocol (gRPC)
runtime    -> marketdata / backtest / broker / execution
CLI        -> operator interface
```

MCP is introduced as another delivery/control adapter, not a replacement for
runtime contracts:

```text
                 +-------------------+
                 |   AI Client       |
                 +---------+---------+
                           |
                           | MCP
                           v
                 +-------------------+
                 |   trader-mcp      |
                 +---------+---------+
                           |
                     Trader services
                           |
          +----------------+----------------+
          |                |                |
      marketdata        research        backtest
```

## Choosing the MCP boundary

MCP should sit **outside** the high-frequency strategy runtime.

```text
Strategy Protocol / gRPC
  high-frequency runtime contract
  deterministic strategy callbacks
  bars / fills / intents

MCP
  human/agent-facing control plane
  research queries
  inspection
  orchestration
```

Why this distinction matters:

- Strategy Protocol is for bar-by-bar execution semantics.
- MCP is for operator and research workflows.
- Replacing the strategy contract with MCP would blur timing, ownership, and
  safety expectations.

MCP should orchestrate domain capabilities, not become the runtime loop.

## Building `trader-mcp` in Go

The implementation direction is:

1. use the official Go MCP SDK as the transport/protocol layer
2. add `cmd/trader-mcp` as a focused adapter entrypoint
3. wire internal Trader services (market data, backtest, metadata)
4. keep MCP handlers thin and delegate computation to existing services

Conceptually:

```go
func main() {
    deps := traderapp.NewServices(...)

    srv := mcp.NewServer("trader-mcp", trader.Version())
    registerReadOnlyTools(srv, deps)

    // stdio for local MCP clients first
    if err := mcpstdio.Serve(srv); err != nil {
        log.Fatal(err)
    }
}
```

The important design rule is thin adapters: avoid moving business logic into MCP
handlers.

## Start with a deliberately small read-only tool set

Initial tool surface:

- `trader_version`
- `trader_instruments`
- `trader_marketdata_coverage`
- `trader_run_backtest`
- `trader_backtest_result`

Example schema shape:

```json
{
  "name": "trader_run_backtest",
  "inputSchema": {
    "type": "object",
    "properties": {
      "strategy": {"type": "string"},
      "instrument": {"type": "string"},
      "interval": {"type": "string"},
      "start": {"type": "string", "format": "date-time"},
      "end": {"type": "string", "format": "date-time"}
    },
    "required": ["strategy", "instrument", "interval", "start", "end"]
  }
}
```

The first version stays intentionally small to optimize for:

- schema clarity
- predictable behavior
- observability and logging
- safe iteration before any mutation semantics

## Exposing resources

Useful resource directions:

- `trader://strategies`
- `trader://datasets`
- `trader://backtests/{run_id}`

A resource is better than a tool when the client is reading stable artifacts
rather than requesting a stateful operation.

In the initial implementation, resources can be deferred while tool contracts
stabilize. If deferred, that should be explicit in docs and API planning.

## Example AI workflow: real backtest loop

A practical agent conversation could look like this:

1. “What Stooq data do I have for SPY?”
2. “Run SMA Long Hold over the development period.”
3. “Show me the result and the market-data provenance used.”

Conceptual MCP call flow:

```text
tools/call trader_marketdata_coverage
  -> {provider:"stooq", instrument:"SPY", interval:"1d", span:{start,end}, dataset_revision}

tools/call trader_run_backtest
  -> {run_id:"bt_20260920_...", status:"completed"}

tools/call trader_backtest_result
  -> {run_id, metrics..., dataset_provenance..., trader_version}
```

The model can narrate and compare; Trader computes and returns the facts.

## Return structured results, not prose

Backtest/result tools should return domain values such as:

- run ID
- provider
- instrument
- interval
- time range
- strategy identity
- net return
- CAGR
- max drawdown
- exposure
- trade count
- dataset revision/fingerprint
- Trader version

Structured payloads allow:

- deterministic post-processing
- reproducible reporting
- easier comparison across runs

## Provenance and reproducibility

Trader already treats reproducibility as a first-class concern:

- raw provider identity preserved
- canonicalized dataset outputs
- manifests and fingerprints
- strategy identity
- Trader build/version recorded in outputs

This is especially important when an AI orchestrates research. The model should
be able to cite *exactly* what dataset and build produced a result.

## Security and destructive-action boundaries

Intentionally out of scope for the initial MCP surface:

- `submit_order`
- `cancel_order`
- `replace_order`
- `enable_live_trading`
- broker credential operations
- arbitrary shell / filesystem tools

Capability tiers should remain explicit:

- read/research tools (default)
- paper-trading mutation tools (opt-in)
- live-trading mutation tools (separate auth + explicit confirmation)

## What not to expose

Avoid common mistakes:

- mapping every CLI command directly into MCP
- exposing arbitrary shell access “for flexibility”
- leaking internal implementation details as public contracts
- moving trading math/data integrity checks into model-side logic

MCP should be a boundary around application services, not a bypass around them.

## Where this goes next

Likely follow-up capabilities:

- strategy listing and description
- backtest comparisons across configs
- universe-level batch research
- cross-instrument robustness analysis
- journal/report inspection resources
- read-only account/position tools
- long-running research job orchestration
- remote deployment/auth controls

## Implementation notes and source links

This article is tied to the real Trader codebase, not a toy demo:

- Trader repository: [github.com/rustyeddy/trader](https://github.com/rustyeddy/trader)
- Strategy Protocol boundary: [`protocol/`](https://github.com/rustyeddy/trader/tree/master/protocol)
- Runtime/backtest internals: [`internal/backtest/`](https://github.com/rustyeddy/trader/tree/master/internal/backtest)
- Market data and manifests: [`marketdata/`](https://github.com/rustyeddy/trader/tree/master/marketdata)
- CLI entrypoint: [`cmd/trader/`](https://github.com/rustyeddy/trader/tree/master/cmd/trader)

`trader-mcp` implementation links and PR references should be added here as that
work lands.

## Closing

MCP gives us a way to let an AI use Trader without turning the AI into Trader.

That separation keeps architecture clean: models choose questions, and the
application remains accountable for answers.

---
title: Trader — FX Backtesting and Live Trading Engine
date: 2026-05-22
description: >
  A Go engine for backtesting and live paper-trading Forex strategies against
  OANDA, with a REST/WebSocket API, embedded UI, and Claude MCP tool
  integration for querying accounts and running backtests from an AI assistant.
github: https://github.com/rustyeddy/trader
project_status: Active
tags: ["Go", "Trading Systems", "Backtesting", "Financial Software"]
categories: ["Projects", "Financial Software"]
---

Trader is a Forex backtesting and live paper-trading engine written in Go.
It downloads historical candle data, runs configurable strategies against
that data, and — using the same strategy interface — executes those same
strategies live against an OANDA practice or live account. A REST and
WebSocket API, an embedded web UI, and a Claude MCP server round out the
system.

## Project Status

**Active.** Trader is a current Go project and an active case study
for trading-system architecture, testing, and exact numeric types.

## Why This Matters

Trader is a software architecture case study in a domain where small mistakes
matter. It connects interface design, exact numeric types, repeatable tests, and
release discipline to a system that must behave consistently in simulation and
live execution.

## The Problem

Building a trading strategy is straightforward. Knowing whether it works
is not. The gap between "this looks good on a chart" and "this survives
statistical scrutiny across years of data" is where most strategy ideas die.

Trader addresses this by making the path from idea to verified result as
short as possible: write a strategy, point it at historical data, get a
report. The same strategy then runs live without modification.

## Architecture

The core backtest pipeline is a linear data flow:

```
Config (YAML) → DataManager → Backtest → Strategy → Broker → Account → Journal
```

**Config** — a YAML file specifies the instrument, date range, starting
balance, risk percentage per trade, stop and take-profit sizing, and which
strategy to run.

**DataManager** — loads historical candle data from the local store, built
from Dukascopy tick data or OANDA candle downloads.

**Backtest** — feeds candles one at a time to the strategy, routes the
resulting orders through the broker, and accumulates the trade record.

**Strategy** — a single Go interface:

```go
type Strategy interface {
    Name() string
    Reset()
    Ready() bool
    Update(ctx context.Context, candle *CandleTime, bt *Backtest) *StrategyPlan
}
```

`Update` receives the current candle and returns a plan — open, close, or
hold. It knows nothing about whether it is running in a backtest or live.
That is the key design property: the strategy is pure logic, isolated from
execution.

**Broker** — executes the plan. In backtesting, the broker simulates fills
with configurable slippage and spread filters. In live trading, the broker
calls the OANDA API.

**Account** — tracks balance, open positions, margin, and unrealized P/L.
Accounting invariants are enforced: `Equity = Balance + UnrealizedPL`,
`FreeMargin = Equity − MarginUsed`.

**Journal** — records every closed trade for reporting and analysis.

## Key Design Decisions

**Fixed-point arithmetic for all financial values.** `Price` is `int32`
scaled at 100,000 (five decimal places — standard forex pip precision).
`Money` is `int64` scaled at 1,000,000. `Pips` is `int32` scaled at 10.
Floats appear only at I/O boundaries — parsing config and formatting output.
See [Numeric Types in Financial Software](/software/numeric-types-financial-software/)
for the reasoning.

**One strategy interface, two execution environments.** The `Strategy`
interface is the only contract between business logic and the execution
engine. Swapping the broker from a simulation to a live OANDA connection
requires no changes to the strategy. See
[The Strategy Pattern in a Backtesting Engine](/software/strategy-pattern-backtesting/)
for the architecture.

**Regression testing for strategies.** The `trader backtest regress` command
runs every YAML config in a directory and writes JSON and org-mode reports.
A strategy that passes unit tests but degrades on out-of-sample data is
caught before it touches a live account.

## Strategies

| Strategy | Description |
|---|---|
| `emacross` | EMA crossover — fast/slow moving average |
| `emacrossadx` | EMA crossover filtered by ADX trend strength |
| `donchian` | Donchian channel breakout |
| `pulse` | Mechanical open/close on a fixed tick schedule |
| `noop` | Baseline — does nothing, establishes spread/slippage cost |

New strategies implement the four-method `Strategy` interface. The `tmpl`
strategy is a documented starting point.

## MCP Integration

`trader-mcp` is an MCP server over stdio, built on the official Go SDK, that
exposes Trader's research capabilities as typed tools for Claude Code and
Claude Desktop:

| Tool | Description |
|---|---|
| `trader_version` | Build identity of the running server |
| `trader_instruments` | Resolve symbols to instruments for a data provider |
| `trader_marketdata_coverage` | Canonical data coverage, partitions, and gaps |
| `trader_run_backtest` | Run a backtest and return its run ID and summary |
| `trader_backtest_result` | Full stored report for a run ID |
| `trader_marketdata_update` | Download and build market data (write-gated) |
| `trader_marketdata_canonicalize` | Build canonical data from raw data (write-gated) |

Read tools are always available. Tools that change data refuse unless the
server is started with `--allow-writes`, so an AI assistant can explore data
and run backtests without changing anything by accident. The server does not
place orders.

See [Build an MCP Server in Go](/notes/mcp-claude-tools/) for how it is built
and the patterns behind it.

## Data Sources

- **Dukascopy** — free tick data, aggregated into OHLC candles locally:
  `trader data sync --instruments EUR_USD --from 2022-01 --to 2024-12`
- **OANDA** — candles via API (requires token):
  `trader data oanda --instrument EUR_USD --granularity H1 --from 2024-01-01`

Candle data is stored under `$DATA_DIR` as
`/<source>/<INSTRUMENT>/<YYYY>/<MM>/`, keeping sources and instruments
cleanly separated.

## GitHub

[rustyeddy/trader](https://github.com/rustyeddy/trader)

## Common Pitfalls

Trading engines become unreliable when backtest and live code diverge, when
strategies depend on broker-specific behavior, when floating-point arithmetic
crosses domain boundaries, or when reports cannot be reproduced from a known
configuration and data set.

## Where This Fits

Trader connects most directly to [The Strategy Pattern in a Backtesting Engine](/software/strategy-pattern-backtesting/)
and [Fixed-Point Numeric Types in Go Financial Software](/software/numeric-types-financial-software/).
Use the project page as the case study and those articles for the focused design lessons.

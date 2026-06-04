---
title: Trader — FX Backtesting and Live Trading Engine
date: 2026-05-22
description: >
  A Go engine for backtesting and live paper-trading Forex strategies against
  OANDA, with a REST/WebSocket API, embedded UI, and Claude MCP tool
  integration for querying accounts and running backtests from an AI assistant.
github: https://github.com/rustyeddy/trader
tags: ["Go", "Trading Systems", "Backtesting", "Financial Software"]
categories: ["Projects", "Financial Software"]
---

Trader is a Forex backtesting and live paper-trading engine written in Go.
It downloads historical candle data, runs configurable strategies against
that data, and — using the same strategy interface — executes those same
strategies live against an OANDA practice or live account. A REST and
WebSocket API, an embedded web UI, and a Claude MCP server round out the
system.

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

`trader mcp` starts an MCP server over stdio, exposing Trader as typed tools
for Claude Code and Claude Desktop:

| Tool | Description |
|---|---|
| `get_account_summary` | Balance, NAV, margin, unrealized P/L |
| `list_open_trades` | All open OANDA positions |
| `run_backtest` | Run a YAML config, return summary |
| `place_order` | Risk-sized market order (write-gated) |
| `close_trade` | Full or partial close by trade ID (write-gated) |
| `update_stop` | Move stop-loss or take-profit (write-gated) |

Read tools are always available. Write tools require `--enable-write` at
startup. This means you can query your account, review open trades, and run
backtests from an AI assistant without ever accidentally placing an order.

See [Exposing a Go App as Claude MCP Tools](/notes/mcp-claude-tools/) for
the implementation approach.

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

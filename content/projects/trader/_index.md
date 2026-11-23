---
title: "Trader: A Go Framework for FX Strategy Research and Backtesting"
date: 2026-05-22
lastmod: 2026-11-23
description: "Trader is an open-source Go framework for FX strategy research: exact fixed-point numbers, a market-data pipeline, and a deterministic backtest engine."
github: https://github.com/rustyeddy/trader
project_status: Active
tags: ["Go", "Trading Systems", "Backtesting", "Financial Software"]
categories: ["Projects", "Financial Software"]
---

Trader is a Go framework for researching FX trading strategies. It downloads
historical OANDA candles into a local store, builds them into canonical bars
with a known availability time, and runs strategies against those bars in a
deterministic backtest with a simulated broker. Prices, quantities and money
are exact fixed-point values throughout.

## Project Status

**Backtesting today; no live or paper trading.** In November 2026 Trader was
restarted from a small, executable design. The earlier, broader code
(including an MCP server and earlier strategy, indicator and analysis
packages) was moved to `_archive/` and is being ported back one layer at a
time, market data first. This page describes the code as of
[trader@a0e3283](https://github.com/rustyeddy/trader/tree/a0e3283) (November
2026).

What works today:

- Downloading OANDA bid/ask candles into a raw store, and building canonical
  bars from them with every rejected row kept and counted
- Data status, verification and integrity-audit commands for a date range
- A deterministic backtest engine and simulated broker, with the EMA crossover
  (EMAX) strategy
- A read-only REST API over the canonical bars (`trader serve`)

Not available: paper trading is planned, and real-money execution is neither
available nor scheduled. Trader's own
[README](https://github.com/rustyeddy/trader/blob/a0e3283/README.md) puts it
plainly: it is not ready for real-money trading.

## Why This Matters

Trader is a software architecture case study in a domain where small mistakes
are expensive and easy to miss. A backtest can look profitable because it used
a price before it was knowable, because a float rounded the wrong way, or
because the data had a quiet gap. Trader's design treats each of those as a
boundary with an owner and a test, which is the same discipline any system
with money or time in it needs.

## Design Principles

Trader's README states the principles the restart is built on:

- **Simple and understandable:** concrete types, ordinary functions, small
  interfaces, and no abstraction without a present use.
- **Deterministic by design:** time, identifiers and data order are
  controllable, so a backtest is reproducible, and a bar is usable only from
  its availability time.
- **Exact numbers:** prices, quantities and money are fixed-point values,
  never floats on the authoritative path.
- **No invented data:** no synthetic or carried-forward bars. Bad source rows
  are kept and counted, never hidden.
- **Layered:** transports call application services, which coordinate domain
  services and providers, and one package owns all data-file I/O.

## Architecture

The data path and the backtest path are separate:

```text
OANDA ──download──> raw store ──build──> canonical bars ──> backtest engine
                    (bid/ask, by month)   (mid price,         (strategy decides,
                                           availability time)  simulated broker fills)
```

**Market data.** `trader data download` writes bid/ask candles for a UTC range
into month partition files. `trader data build` converts them to canonical
bars with a mid price and a modeled availability time, the moment the bar
could actually have been observed. `status`, `verify` and `audit` commands
report which months are loadable, whether canonical bars still match the raw
data they came from, and where the gaps are.

**The engine.** A strategy receives the bars that became available at one
instant and returns the orders it wants. The simulated broker processes each
group of bars before the strategy sees it, so an order can only fill on a
later bar. [The Strategy Pattern in a Go Backtesting Engine](/software/strategy-pattern-backtesting/)
walks through that boundary in detail.

**Packages.** One package owns all data-file reads and writes
(`internal/store`), the market-data model is public (`marketdata`), the OANDA
code is a provider (`provider/oanda`), and the command line holds no domain
logic (`cmd/trader`). The dependency rules are enforced by tests.

## Key Design Decisions

**Exact fixed-point numbers.** `Price`, `Quantity`, `Rate` and `Money` are
semantic types over a single common scale of 1e8 (eight decimal places), with
checked arithmetic and explicit rounding. `Money` carries its currency. Code
outside the `num` package never touches the raw scaled integers. See
[Money in Go: Fixed-Point Types for Financial Software](/software/numeric-types-financial-software/)
for the reasoning.

**Availability time, not candle time.** Every bar records when it could have
been observed, and the engine groups bars by that time. A strategy can't be
handed a completed candle before its close was knowable, which removes a
common source of look-ahead bias.

**Bad data is kept and counted.** The canonical build never drops or invents
a bar silently. Rejected rows are recorded, and the audit command reports
them, so a gap in the data shows up as a gap in the report instead of as a
better backtest.

**A regression check on every change.** Every pull request must leave the
EMAX backtest summaries byte-for-byte unchanged (the README publishes the
checksum), so a refactor that shifts a result is caught before it merges.

**Decisions are written down.** Architecture decisions are recorded as ADRs in
the repository, and AI agents working in the repo follow its `AGENTS.md`. That
record is also the source for future articles on this site.

## MCP Integration

An earlier version of Trader included `trader-mcp`, an MCP server that let
Claude query market data and run backtests. It was archived with the rest of
the earlier code during the restart. Its design decisions are kept as ADRs, and
it is planned to return once the layers it depends on are ported.
[Build an MCP Server in Go](/notes/mcp-claude-tools/) covers how it was built.

## Repository

[rustyeddy/trader](https://github.com/rustyeddy/trader): the
[User's Guide](https://github.com/rustyeddy/trader/blob/a0e3283/docs/UsersGuide.md)
covers the commands, configuration and data layout.

## Common Pitfalls

Trading engines become unreliable when a strategy can see data before it was
available, when strategies depend on broker-specific behavior, when
floating-point arithmetic crosses domain boundaries, when bad source data is
silently dropped or patched, or when results can't be reproduced from a known
configuration and data set.

## Where This Fits

Trader connects most directly to
[The Strategy Pattern in a Go Backtesting Engine](/software/strategy-pattern-backtesting/)
and [Money in Go: Fixed-Point Types for Financial Software](/software/numeric-types-financial-software/).
Its release process is the example in
[Software Release Process: A Checklist for Small Teams](/software/release-process/).
Use this page as the case study and those articles for the focused design
lessons.

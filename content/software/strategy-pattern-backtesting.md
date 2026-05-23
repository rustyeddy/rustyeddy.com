---
title: The Strategy Pattern in a Backtesting Engine
date: 2026-05-22
description: >
  How to design a strategy interface that runs identically in simulation
  and live trading — separating business logic from execution so strategies
  can be developed, tested, and deployed without modification.
---

A backtesting engine and a live trading engine solve the same problem: given
market data, decide what to do, then do it. The data source changes (history
versus a live feed), the broker changes (a simulator versus a real exchange),
but the decision logic — the strategy — should not change at all.

This is not obvious when you first build one of these systems. The natural
instinct is to write the strategy and the execution engine together, letting
the strategy reach directly into the data feed or the broker. That works for
a prototype. It makes testing hard, live deployment risky, and strategy
comparison unreliable because each strategy is tested against a slightly
different engine.

The [Trader](https://github.com/rustyeddy/trader) project separates these
concerns with a four-method interface that is the only contract between
strategy logic and the execution engine.

## The Strategy Interface

```go
type Strategy interface {
    Name() string
    Reset()
    Ready() bool
    Update(ctx context.Context, candle *CandleTime, bt *Backtest) *StrategyPlan
}
```

**`Name()`** — returns a string identifier used in reports and logs.

**`Reset()`** — clears all internal state. Called between backtest runs so
a strategy can be reused across multiple date ranges or parameter sets
without instantiating a new object.

**`Ready()`** — returns true when the strategy has accumulated enough data
to generate a signal. An EMA crossover strategy needs at least `slow_period`
candles before it can produce a meaningful signal; before that, `Ready()`
returns false and `Update()` is not called.

**`Update(ctx, candle, bt)`** — the core method. Receives the current candle
and the backtest state, returns a `StrategyPlan` describing what to do: open
a position, close one, adjust a stop, or hold. If there is nothing to do,
it returns nil.

That is the entire interface. A strategy has no access to the broker, no
knowledge of how orders are filled, and no awareness of whether it is running
in a simulation or against a live account.

## The Backtest Pipeline

The engine feeds candles one at a time through a linear pipeline:

```
Config (YAML) → DataManager → Backtest → Strategy → Broker → Account → Journal
```

At each bar, the engine calls `strategy.Update()`, takes the returned plan,
and routes it to the broker. The broker applies slippage, checks spread
filters, and records the fill. The account updates its positions and margin.

```go
// Simplified inner loop
for _, candle := range candles {
    if !strategy.Ready() {
        continue
    }
    plan := strategy.Update(ctx, candle, bt)
    if plan != nil {
        broker.Execute(plan, candle, account)
    }
}
```

The strategy never calls `broker.Execute` directly. It returns a plan and
the engine routes it. This is the dependency inversion that makes the
interface portable.

## Live Trading

For live trading, the same loop runs against a real-time candle feed. The
broker implementation changes — instead of simulating a fill, it calls the
OANDA API:

```go
// Backtest broker: simulates fill with slippage
type SimBroker struct { SlippagePips Pips }

// Live broker: calls OANDA REST API
type OANDABroker struct { Client *oanda.Client }
```

Both implement the same `Broker` interface. The strategy is constructed
once and handed to whichever engine is running. No code in the strategy
changes.

This matters practically: a strategy that has been verified in backtest
is exactly the strategy that runs live. There is no translation layer, no
"live version" of the logic that might diverge from the tested version.

## Context-Injected Runtime State

The `ctx` parameter carries runtime information the strategy may need without
coupling it to the engine:

```go
// Retrieved inside Update() via helper functions:
instrument := StrategyInstrument(ctx)  // "EUR_USD"
barIndex   := StrategyBarIndex(ctx)    // current bar number
account    := StrategyAccount(ctx)     // read-only account snapshot
```

The strategy reads this via accessor functions rather than directly from the
engine, keeping the coupling one-directional. The strategy reads from context;
it never writes to it.

## Testing Strategies in Isolation

Because a strategy is a pure function over candles, it can be tested without
a real data feed or broker. The `fake` and `noop` strategies are examples of
this:

- `noop` does nothing — it establishes the baseline cost of spread and
  slippage without any trading logic, providing a benchmark for comparison.
- `fake` executes a scripted sequence of actions for deterministic tests —
  useful for verifying that the accounting, P/L calculation, and journal
  logic work correctly independent of any real strategy behavior.

Any strategy can be tested by constructing it, feeding it synthetic candles,
and asserting on the returned `StrategyPlan`:

```go
s := emacross.New(Config{Fast: 9, Slow: 21})
for _, c := range testCandles {
    plan := s.Update(ctx, c, bt)
}
// assert on the trade record
```

No broker, no OANDA credentials, no live data required.

## Regression Testing

`trader backtest regress` runs every YAML config in a directory and writes
JSON and org-mode reports. A strategy that behaves differently after a code
change will show up immediately in the regression output — before it touches
a live account.

This is the same principle as a test suite for application code: changes
should be validated against known-good baselines. For trading strategies, the
baseline is a specific set of inputs (historical data, config) that should
produce a specific set of outputs (trade count, net P/L, win rate).

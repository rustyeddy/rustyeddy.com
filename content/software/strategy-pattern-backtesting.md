---
title: "The Strategy Pattern in a Go Backtesting Engine"
date: 2026-05-22
lastmod: 2026-11-23
description: "Design a Go backtesting strategy interface that separates decisions from simulated fills, handles bar availability, and makes order timing testable."
tags: ["Go", "Trading Systems", "Strategy Pattern", "Backtesting", "System Design"]
categories: ["Software Engineering", "Financial Software"]
summary: "How Trader separates strategy decisions from simulated execution, and how to test the timing and state at that boundary."
---

A strategy can decide to buy after reading a bar's close. The simulator
still has to decide when that order could have filled. If the strategy
also books the fill, a test can pass while quietly using a price from
before the decision was possible.

The strategy pattern gives those two decisions different owners. In
[Trader](/projects/trader/), the strategy returns the orders it wants.
The runner submits them and the simulated broker decides what fills.
That split lets you test a trading rule with a few bars and test the
execution model separately.

## Why this matters

The boundary lets a reviewer ask two questions independently: did the
strategy request the expected order, and could the broker have filled it
at that price and time? When both answers come from one component, a
change to signal logic can also change the assumptions behind its results.

Trader provides the worked example. The source links below are pinned
to the same revision. That revision supports backtesting with a simulated
broker. Its [README](https://github.com/rustyeddy/trader/blob/a2d1475bd656d47d0a6dbe135b69bba7d8d22099/README.md)
lists paper trading as planned and real-money execution as unavailable.

## The strategy interface

Trader's [strategy contract](https://github.com/rustyeddy/trader/blob/a2d1475bd656d47d0a6dbe135b69bba7d8d22099/strategy.go)
is internal to the Go package. This is the interface declaration from
the source:

```go
type strategy interface {
    name() string
    init() error
    onBars(ctx context.Context, bars []marketdata.Bar) ([]*order, error)
}
```

`init` gives a strategy a place to validate its inputs and initialize
state. A call to `onBars` receives the bars that became available at one
instant, in instrument order. A single-instrument call uses the same
interface with one bar. A symbol without a new bar at that instant is
absent from the group. The slice is valid only for that call.

The return value distinguishes three outcomes: orders to submit, no orders,
or an error that stops the run before any returned order is submitted.
Returning an order expresses a request. An order can reserve margin when submitted. It opens or closes a
position only if it fills.

## Process the bars before submitting new orders

![Trader groups newly available bars, lets the simulated broker process that frame, then calls the strategy and submits any returned orders. Those orders are eligible for execution on later bars.](/diagrams/backtest-strategy-boundary.svg)

Trader's [runner](https://github.com/rustyeddy/trader/blob/a2d1475bd656d47d0a6dbe135b69bba7d8d22099/trader.go)
advances the simulated broker through the frame before calling the strategy.
The strategy sees the entire group before any of its new orders is submitted.
The runner submits orders in the returned order. That order matters when
two requests compete for margin: the second is sized after the first has
reserved margin.
In the [market-order test](https://github.com/rustyeddy/trader/blob/a2d1475bd656d47d0a6dbe135b69bba7d8d22099/broker_test.go),
the order fills at the next bar's open. The decision bar has already been
processed.

Availability matters when several instruments are involved. Group by when
each bar can be observed. Grouping by candle open time can hand a strategy
a completed candle before its close was knowable. The same rule makes a
single-symbol replay easier to audit: you can trace which data was visible
at each decision and which bar the broker used for execution.

## Make warm-up and state explicit

Some strategies need history before they can make a decision. Trader
handles that with a separate optional `warmer` interface. The backtest
passes bars whose opening time precedes the trading start to strategies
that support warm-up and keeps those bars away from the broker. That gives an indicator history without also
giving the account a position before the run begins.

Keep indicator state, signal state, and account state distinct. The EMA
crossover implementation, for example, records the last entry signal it
consumed. That field can differ from the actual position after a simulated
stop. A test of the signal and a test of the account should therefore
assert different things. Trader also supports optional broker feedback
before the next strategy decision for strategies that need execution events.
That feedback is an explicit input, separate from submitting an order.

## Test the boundary at two levels

1. Feed an initialized strategy known bars and assert on the orders it
   returns. Cover insufficient history, the first actionable input, and
   repeated runs with fresh state.
2. Run the strategy through the backtest runner and assert on submissions
   and fills. Cover warm-up bars that never trade, simultaneous bars
   delivered in one call, and a market order filling on the next bar.

Trader has [strategy tests](https://github.com/rustyeddy/trader/blob/a2d1475bd656d47d0a6dbe135b69bba7d8d22099/strategy_test.go),
[backtest warm-up tests](https://github.com/rustyeddy/trader/blob/a2d1475bd656d47d0a6dbe135b69bba7d8d22099/backtest_test.go),
and a [frame-ordering test](https://github.com/rustyeddy/trader/blob/a2d1475bd656d47d0a6dbe135b69bba7d8d22099/twosymbol_test.go)
for those cases. A fixture with just a few bars can expose an ordering
change that a comparison of aggregate returns would miss.

## Common pitfalls

- **Letting the strategy call a broker.** A decision test now needs an
  execution environment and can accidentally depend on a broker's behavior.
- **Giving replay and live code different decision inputs.** If a future
  live adapter supplies account or time data the replay cannot reproduce,
  sharing the strategy code won't make the decisions comparable. Define
  those inputs explicitly and test equivalent event sequences.
- **Hiding run state.** A shared indicator or an implicit clock makes the
  next run depend on the previous one. Control their lifetimes and inputs
  in tests.
- **Treating a request as a fill.** Rejections, delays and fill prices
  belong to execution. A strategy test that asserts only its request tells
  you nothing about the account after that request.

## Where this fits

A narrow strategy interface makes hypothetical live execution easier to
reason about. It cannot establish how another broker will handle latency,
gaps, rejections, or partial fills. Those are separate contracts with
their own tests.

For the rest of the system, see the [Trader project](/projects/trader/).
The same boundary discipline applies to [fixed-point money types in Go](/software/numeric-types-financial-software/)
and to [testing expected behavior](/software/test-driven-software-development/).

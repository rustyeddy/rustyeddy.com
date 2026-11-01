---
title: "Money in Go: Fixed-Point Types for Financial Software"
date: 2026-05-22
description: >
  Why float64 is wrong for prices and money in Go, and how Trader keeps
  financial values exact with semantic fixed-point types, one common scale,
  and checked arithmetic.
tags: ["Go", "Financial Software", "Fixed-Point Arithmetic", "Numeric Types", "Trading Systems", "ADR"]
categories: ["Software Engineering", "Financial Software"]
summary: "How Trader represents prices, money, quantities, and rates in Go: semantic fixed-point types, one 1e8 scale, currency-carrying Money, and a one-way float64 boundary."
---

Financial software has one rule about numbers that is not negotiable:
authoritative prices and money never live in a `float64`.

This article walks through how the [Trader project](/projects/trader/)
applies that rule in Go. It is based on the current `num` package and on
[ADR-004](https://github.com/rustyeddy/trader/blob/c1b7f932f9cba508c30aa7e7f9a6260e0b235267/docs/arch/adr-004-exact-numeric-representation.org),
the architecture decision record that defines it. Every snippet below was
compiled and run against that code.

## Why This Matters

A numeric representation is a design decision, and money is where a vague
one costs real dollars. When prices, balances, quantities, and rates all share
`float64`, nothing in the type system says which is which, rounding happens
wherever arithmetic happens, and results can vary in the last digit when the
order of operations changes. Those are not style problems. They are
reconciliation bugs, and they show up in production rather than in review.

## Why Floats Fail

`float32` and `float64` use binary fractions, and most decimal values have no
exact binary representation. `0.1` is stored as an approximation:

```go
var sum float64
for i := 0; i < 10; i++ {
    sum += 0.1
}
fmt.Println(sum) // 0.9999999999999999
```

In one calculation this is a curiosity. In a system that accumulates prices,
fills, fees, spreads, margin, and P/L, it becomes balances that do not
reconcile and results that change with the order of operations.

IEEE 754 is the right tool for science and graphics, where small relative
error is acceptable. Accounting and trading need explicit precision limits and
rounding rules.

## Four Types, One Scale

Trader defines four semantic numeric types: `Price`, `Money`, `Quantity`, and
`Rate`. Each wraps an unexported `int64`:

```go
type Price struct {
    raw int64
}
```

Every one of them uses the **same scale, 1e8**: a decimal value `v` is stored
as `v × 100_000_000`. That gives eight decimal places and a range of roughly
±92 billion.

One common scale was a deliberate choice. An earlier version of this article
described a different scale per type (prices at five decimal places, money at
six). That works for spot FX and breaks down as soon as the system needs
equities, crypto, or fractional quantities. A common scale also means
`Price × Quantity → Money` uses the same fixed-point scale for both operands
and the result. `Price.MulQuantity` still restores the 1e8 scale after
multiplying and rounds half-even.

ADR-004 is explicit that the scale is an *internal representation detail*.
It is not a tick size, a display precision, or a wire format. Tick size and
display precision belong to the instrument, which keeps those rules out of the
number type.

## Type Safety

Because each type is its own struct, mixing them does not compile:

```go
price := num.MustParsePrice("1.08457")
balance := num.MustParseMoney("10000", num.MustParseCurrency("USD"))

price.Add(balance)
// cannot use balance (variable of struct type num.Money)
// as num.Price value in argument to price.Add
```

Conversions that cross types are methods that encode a real rule. The
notional value of a position is a price times a quantity, denominated in an
explicit currency:

```go
usd := num.MustParseCurrency("USD")
qty := num.MustParseQuantity("10000")

notional, err := num.MustParsePrice("1.08457").MulQuantity(qty, usd)
// notional: 10845.7 USD
```

Neither `Price` nor `Quantity` carries a currency, so the caller has to say
which currency the result is in.

## Money Owns Its Currency

`Money` is the one type with metadata attached: a mandatory `Currency`. Its
zero value is invalid, so "zero dollars" has to be constructed explicitly with
a currency.

Cross-currency arithmetic is rejected rather than coerced:

```go
usd := num.MustParseCurrency("USD")
eur := num.MustParseCurrency("EUR")

balance := num.MustParseMoney("1000", usd)
_, err := balance.Add(num.MustParseMoney("2.50", eur))
// err: num: currency mismatch

converted, err := balance.Convert(eur, num.MustParseRate("0.92"))
// converted: 920 EUR
```

`Convert` is the only method that changes currency, and it requires both a
target currency and an explicit rate. Where that rate came from is the
caller's responsibility.

## Checked Arithmetic and Explicit Rounding

Arithmetic returns an error instead of silently doing the wrong thing:

- **Overflow** is reported, not wrapped. `Price × Quantity` uses a widened
  128-bit intermediate, so a large but realistic notional value does not
  overflow `int64` the way a naive scaled product would.
- **Domain rules** are enforced. `Price` has no negative values, so
  `Price.Sub` returns `ErrNegative` when the result would go below zero.
- **Rounding** is never implicit. Multiplication and division round half to
  even, and tick rounding is a separate, explicit call:

```go
tick := num.MustParsePrice("0.00001")
p := num.MustParsePrice("1.084573")

ok, _ := p.DivisibleBy(tick)  // false
down, _ := p.RoundDown(tick)  // 1.08457
```

Validating a price against an instrument's tick is exact integer arithmetic:
the raw price modulo the raw tick.

## The Boundary Rule

The rule that keeps the design clean:

> Text may cross the boundary. Exact types live inside. `float64` leaves only
> through one explicit, one-way door.

![Exact core with text boundaries in and out, and a one-way float64 conversion to analytics that returns only through checked quantization](/diagrams/fixed-point-boundary.svg)

### Parsing: reject, never round

Input arrives as decimal text, from JSON, broker APIs, config files, or CLI
flags, and is parsed exactly. Anything that does not fit is rejected:

```go
num.ParsePrice("1.123456789") // num: excess decimal precision
num.ParsePrice("-1.5")        // num: negative value not permitted
num.ParsePrice("1e3")         // num: invalid decimal syntax
num.ParsePrice("99999999999") // num: value out of range
```

Rejecting precision you cannot represent is safer than guessing at it in the
middle of the system.

### JSON: strings, not numbers

The types implement `encoding.TextMarshaler` and `json.Marshaler`, so a
struct can use them directly. Prices travel as JSON *strings*, which preserve
the decimal exactly. A JSON number is refused:

```go
type Order struct {
    Instrument string       `json:"instrument"`
    Price      num.Price    `json:"price"`
    Units      num.Quantity `json:"units"`
}

// {"instrument":"EUR_USD","price":"1.08457","units":"1000"}  -> ok
// {"instrument":"EUR_USD","price":1.08457,"units":"1000"}    -> error
```

`Money` serializes as a structured value so the currency cannot be dropped:
`{"amount":"1000","currency":"USD"}`.

### The one float64 door

Indicators and other analytical code genuinely need floating point. Trader
allows that through exactly one exit,
[ADR-045](https://github.com/rustyeddy/trader/blob/c1b7f932f9cba508c30aa7e7f9a6260e0b235267/docs/arch/adr-045-analytical-float64-conversion-boundary.org):
`Price.Float64()`. It is a direct numeric conversion, never a
format-then-reparse round trip.

There is no constructor from `float64` back to `Price` in `num`. If an
analytical result needs to become authoritative again, such as a computed stop
level, the caller must define how to quantize it to the instrument's tick and
represent it as decimal text before checked parsing. That conversion policy
belongs to the caller; `num` supplies no float-to-`Price` conversion.

## Enforced, Not Just Documented

Two mechanisms keep the rule from eroding as the code base grows, and both
matter more once AI agents are writing code alongside you:

- **An architecture test** parses the `num` package source and fails if
  `float32` or `float64` appears anywhere except inside a method named
  `Float64`.
- **Go's `internal/` visibility** prevents any package outside `num` from
  importing the raw fixed-point mechanics, and a second test checks the same
  rule independently.

A convention that only lives in a style guide gets violated by the first
contributor, human or model, who has not read it. A failing test does not
depend on anyone remembering.

## Why Not Just Use a Decimal Library?

Go has good decimal libraries, and if you need arbitrary precision one of them
is a reasonable choice. Trader's ADR-004 rejects a single generic decimal type
for its public API for a different reason: a `Decimal` is exact but says
nothing about what the value *means*. A generic decimal will happily add a
price to a balance. Distinct semantic types make that a compile error, carry
the currency where it belongs, and attach domain rules (no negative prices,
tick validation) to the type that owns them.

The representation underneath matters less than the semantics on top.

## Common Pitfalls

### Letting floats past the boundary

Convenience pulls floats inward one function at a time. Convert once at the
edge and make the reverse trip deliberately expensive.

### Silent rounding

Rounding hides invalid input. Decide where rounding is allowed (tick
rounding, rate multiplication) and reject excess precision everywhere else.

### One type for everything

A single numeric type, exact or not, cannot tell a price from a quantity.
Named types catch mistakes that a generic decimal cannot.

### Currency as a separate variable

Passing `amount` and `currency` side by side invites them to drift apart.
Make the currency part of the money value.

### Format-and-reparse loops

Strings are for humans, logs, and wire formats. Do not use them as an
intermediate step in a calculation.

## Where This Fits

- [Trader: FX Backtesting and Live Trading Engine](/projects/trader/)
  describes the project these types come from.
- [The Strategy Pattern in a Backtesting Engine](/software/strategy-pattern-backtesting/)
  shows how strategy logic stays separate from execution.
- The full rationale, including the range and rounding tables, is in
  [ADR-004](https://github.com/rustyeddy/trader/blob/c1b7f932f9cba508c30aa7e7f9a6260e0b235267/docs/arch/adr-004-exact-numeric-representation.org)
  and the [`num` package](https://github.com/rustyeddy/trader/tree/c1b7f932f9cba508c30aa7e7f9a6260e0b235267/num).

The same rule applies beyond trading. If a value is a price, balance, fee,
tax, quantity, or rate, decide its representation explicitly, before it
reaches the core of the system.

---
title: Numeric Types in Financial Software
date: 2026-05-22
description: >
  Why floating-point numbers are wrong for prices and money, and how
  fixed-point integers eliminate rounding errors in financial calculations.
---

Financial software has one rule about numeric types that is not negotiable:
never use floating-point for prices or money.

This is not a performance concern or a style preference. It is a correctness
requirement. Floats introduce errors that accumulate across calculations, and
in financial software those errors translate to real discrepancies — in
reported balances, in risk calculations, in trade fills. Understanding why,
and what to use instead, is table stakes for anyone writing systems that
touch money.

## Why Floats Fail

Floating-point numbers (`float32`, `float64`) use binary fractions to
represent decimal values. The problem is that most decimal values cannot
be represented exactly in binary. The number `0.1` has no exact binary
representation — the stored value is approximately
`0.1000000000000000055511151231257827021181583404541015625`.

That error is tiny, but it does not stay tiny:

```go
var sum float64
for i := 0; i < 10; i++ {
    sum += 0.1
}
fmt.Println(sum) // 0.9999999999999999, not 1.0
```

In an isolated calculation this is a curiosity. In a system accumulating
thousands of trades, applying risk percentages, computing P/L across
positions, and reconciling against a broker — it becomes a source of
hard-to-reproduce discrepancies that only appear in production.

The IEEE 754 standard that defines floating-point behavior is well-suited
for scientific computation where small relative errors are acceptable. It is
the wrong tool for accounting, where exactness is the requirement.

## Fixed-Point Integers

The solution is fixed-point arithmetic: represent values as integers with
an implicit scale factor. A price of `1.23456` stored as `int32` with a
scale of 100,000 is simply the integer `123456`. All arithmetic operates on
integers, which are exact. The scale only matters when converting to or from
a human-readable form.

In the [Trader](https://github.com/rustyeddy/trader) project, the financial
types are defined as:

```go
type Price int32   // scaled by 100_000 (5 decimal places)
type Money int64   // scaled by 1_000_000 (6 decimal places)
type Pips  int32   // scaled by 10 (tenths of a pip)

const (
    PriceScale = 100_000  // standard forex pip precision
    MoneyScale = 1_000_000
)
```

Conversion from a float happens only at the boundary — parsing a config
file or an API response:

```go
func PriceFromFloat(f float64) Price {
    return Price(math.Round(f * float64(PriceScale)))
}

func MoneyFromFloat(f float64) Money {
    return Money(math.Round(f * float64(MoneyScale)))
}
```

The `math.Round` call handles the imprecision in the input float, snapping
it to the nearest representable fixed-point value before it enters the
system. From that point forward, all arithmetic is integer arithmetic —
exact by definition.

Output is the mirror image:

```go
func (p Price) Float64() float64 { return float64(p) / float64(PriceScale) }
func (m Money) Float64() float64 { return float64(m) / float64(MoneyScale) }
```

## Choosing Scale Factors

The scale factor determines the precision available. The choice is
domain-specific:

**Forex prices** use five decimal places as standard — a pip is the fourth
decimal place, and brokers quote to the fifth. `Price` as `int32` at
scale 100,000 covers prices up to roughly ±21,474, which is more than
adequate for any currency pair.

**Account balances and P/L** need more headroom and more precision. `Money`
as `int64` at scale 1,000,000 supports balances up to roughly ±9.2 trillion
with six decimal places of precision — enough for any realistic account size.

**Pips** are quoted to one decimal place in modern brokers (fractional pips).
`Pips` as `int32` at scale 10 represents tenths of a pip with integer math.

## Type Safety

Defining distinct named types for `Price`, `Money`, and `Pips` prevents
a class of bugs at compile time. In Go, `Price` and `Money` are different
types even though both are integers — you cannot accidentally add a price
to a balance without an explicit conversion:

```go
var p Price = PriceFromFloat(1.23456)
var m Money = MoneyFromFloat(10_000.0)

// This does not compile:
total := p + m

// This is explicit and intentional:
total := Money(p) + m
```

The compiler enforces dimensional consistency. An account balance cannot be
accidentally treated as a price, and a pip count cannot be silently promoted
to a monetary value.

## The Boundary Rule

The pattern that makes this work cleanly is enforcing a strict boundary: floats
exist only at the edges of the system, at the points of input and output.
Config parsing converts float strings to fixed-point. API responses convert
JSON numbers to fixed-point. Display formats convert back. Everything between
those boundaries is integer arithmetic.

This boundary discipline is what makes the system auditable. If a balance
calculation is wrong, the error is in the business logic — not hiding in
accumulated floating-point noise that shifts with input values and operation
order.

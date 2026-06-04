---
title: "Fixed-Point Numeric Types in Go Financial Software"
date: 2026-05-22
description: >
  Why floating-point numbers are wrong for prices and money, and how
  fixed-point integer types in Go eliminate rounding errors in financial
  calculations.
tags: ["Go", "Financial Software", "Fixed-Point Arithmetic", "Numeric Types", "Trading Systems"]
categories: ["Software Engineering", "Financial Software"]
summary: "A practical guide to fixed-point arithmetic in Go for prices, money, pips, API boundaries, and trading-system correctness."
---

Financial software has one rule about numeric types that is not negotiable:
never use floating-point values for prices or money inside the system.

## Why This Matters

Financial software fails when numeric meaning is implicit. Prices, money,
quantities, and pips need exact representation and clear domain boundaries so
rounding errors and unit mistakes do not become production defects.

This is not a performance concern or a style preference. It is a correctness
requirement. Floating-point values introduce small representation errors, and
financial systems turn small numeric errors into real discrepancies: balances
that do not reconcile, fills that do not match reports, and risk calculations
that shift depending on operation order.

The fix is fixed-point arithmetic: store financial values as integers with an
explicit scale.

## Why Floats Fail

Floating-point numbers such as `float32` and `float64` use binary fractions.
Most decimal values cannot be represented exactly in binary. The decimal
value `0.1` is stored as an approximation, not as exactly one tenth.

```go
var sum float64
for i := 0; i < 10; i++ {
    sum += 0.1
}
fmt.Println(sum) // 0.9999999999999999, not 1.0
```

In an isolated calculation, this looks like a curiosity. In a trading system
that accumulates thousands of prices, fills, fees, spreads, margin values,
and P/L calculations, it becomes a source of reconciliation bugs.

IEEE 754 floating-point arithmetic is excellent for scientific and graphics
work where small relative errors are acceptable. Accounting and trading
systems need exact decimal behavior at the domain boundary.

## Fixed-Point Integers

Fixed-point arithmetic stores values as integers with an implied decimal
scale. A price of `1.23456` stored with a scale of `100_000` becomes the
integer `123456`.

All internal arithmetic happens on integers. The scale only matters when
parsing input, formatting output, or converting between related units.

In the [Trader project](/projects/trader/), the financial types follow this
pattern:

```go
type Price int32 // scaled by 100_000, five decimal places
type Money int64 // scaled by 1_000_000, six decimal places
type Pips  int32 // scaled by 10, tenths of a pip

const (
    PriceScale = 100_000
    MoneyScale = 1_000_000
    PipScale   = 10
)
```

A `Price`, `Money`, and `Pips` value may all be backed by integers, but they
mean different things. The named types keep those meanings visible in code.

## Choosing Scale Factors

The scale factor should come from the domain.

Forex prices commonly use five decimal places. A `Price` stored as `int32`
with scale `100_000` covers values up to roughly +/-21,474, enough headroom
for currency pairs.

Account balances, fees, and P/L need more range. A `Money` value stored as
`int64` with scale `1_000_000` provides six decimal places and very large
headroom.

Pips can use a smaller scale. Modern forex brokers often quote fractional
pips, so storing pips as tenths with scale `10` keeps pip arithmetic exact
without pretending pips are money or prices.

The right scale is a design decision. Make it explicit, name it, and keep it
consistent.

## Type Safety

Named numeric types prevent accidental mixing of financial dimensions.

```go
var price Price = PriceFromString("1.23456")
var balance Money = MoneyFromString("10000.00")

// This does not compile:
// total := price + balance
```

That compile-time failure is useful. A price and an account balance are not
the same kind of value, even if both are represented as integers.

Conversions should be explicit and rare. If code needs to convert between
financial types, the conversion should encode a real business rule: position
size, instrument precision, exchange rate, pip value, or fee calculation.

## The Boundary Rule

The rule that keeps this design clean is simple:

> Floats and strings may exist at the boundary. Fixed-point types exist inside
> the system.

Boundaries include:

- JSON API requests and responses.
- Broker API payloads.
- Configuration files.
- CLI flags.
- Database serialization.
- UI formatting.

Convert external representations into fixed-point types as soon as they enter
the system. Convert fixed-point types back to strings or JSON only when data
leaves the system.

## Parsing from Strings

Parsing decimal strings is safer than accepting floats because the original
decimal representation is still available.

```go
func PriceFromString(s string) (Price, error) {
    r, ok := new(big.Rat).SetString(s)
    if !ok {
        return 0, fmt.Errorf("invalid price %q", s)
    }

    scaled := new(big.Rat).Mul(r, big.NewRat(PriceScale, 1))
    n := new(big.Int).Quo(scaled.Num(), scaled.Denom())

    if !scaled.IsInt() {
        return 0, fmt.Errorf("price %q has too much precision", s)
    }

    return Price(n.Int64()), nil
}
```

Production code may choose a decimal library or a custom parser instead, but
the rule is the same: reject values that do not fit the scale instead of
silently rounding them in the middle of the system.

## JSON/API Boundary Example

APIs often represent prices as JSON strings to preserve decimal precision:

```json
{
  "instrument": "EUR_USD",
  "price": "1.08457",
  "units": "1000"
}
```

Convert that payload at the boundary:

```go
type OrderRequest struct {
    Instrument string `json:"instrument"`
    Price      string `json:"price"`
    Units      string `json:"units"`
}

type Order struct {
    Instrument string
    Price      Price
    Units      int64
}

func (r OrderRequest) ToOrder() (Order, error) {
    price, err := PriceFromString(r.Price)
    if err != nil {
        return Order{}, err
    }

    units, err := strconv.ParseInt(r.Units, 10, 64)
    if err != nil {
        return Order{}, err
    }

    return Order{
        Instrument: r.Instrument,
        Price:      price,
        Units:      units,
    }, nil
}
```

After `ToOrder` succeeds, the rest of the system works with `Price` and
`int64`, not raw JSON strings and not floats.

## Formatting for Output

Output is the mirror image. Keep formatting at the edge:

```go
func (p Price) String() string {
    whole := int64(p) / PriceScale
    frac := abs64(int64(p) % PriceScale)
    return fmt.Sprintf("%d.%05d", whole, frac)
}

func (m Money) String() string {
    whole := int64(m) / MoneyScale
    frac := abs64(int64(m) % MoneyScale)
    return fmt.Sprintf("%d.%06d", whole, frac)
}
```

Formatting should not leak back into the calculation path. Strings are for
humans, logs, APIs, and storage. Typed integers are for business logic.

## Common Pitfalls

### Letting Floats Past the Boundary

Using floats internally because they are convenient defeats the purpose of
fixed-point types. Convert once at the edge and keep floats out of business
logic.

### Silent Rounding

Rounding can hide invalid input. Decide where rounding is allowed and where
precision should be rejected. For prices, rejecting too many decimal places is
often safer than guessing.

### Reusing One Type for Everything

A single `Decimal` type may be exact, but it does not explain whether a value
is a price, money, quantity, or pips. Named domain types catch mistakes that a
generic decimal cannot.

### Choosing the Wrong Scale

A scale that is too small loses precision. A scale that is too large can
reduce headroom or make conversions awkward. Choose based on the instruments,
broker precision, and reporting requirements.

### Mixing Display Formatting with Math

Formatted strings should not become calculation inputs again unless they are
crossing a real system boundary. Avoid parse-format-parse loops inside the
application.

## Where This Fits

Fixed-point numeric types are part of the broader Trader design:

- [The Strategy Pattern in a Backtesting Engine](/software/strategy-pattern-backtesting/)
  shows how strategy logic stays separate from execution.
- [Trader: FX Backtesting and Live Trading Engine](/projects/trader/) explains
  the project that uses these domain types.

The same rule applies beyond trading. If the value is a price, balance, fee,
tax, quantity, or financial rate, make the numeric representation explicit
before it enters the core of the system.

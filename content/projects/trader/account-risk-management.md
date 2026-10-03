---
title: "Account Risk Management for Traders"
date: 2026-09-25
description: "Position sizing, margin, exposure, and drawdown limits: the layered model professional traders use to keep one bad formula from sinking an account."
tags: ["trading", "risk management", "position sizing", "backtesting"]
---

Most trading discussions focus on entries. Most account blowups come from
sizing. This post lays out how account-level risk is handled in practice: the
vocabulary, the math, the constraints each market imposes, and a set of
parameters worth defining before any system trades real money.

## The trap: risk-per-trade alone is unbounded

The standard advice is to "risk 1% per trade." Position size then comes from
the stop distance:

```
units = (equity × riskPct) / |entry − stop|
```

That formula has no ceiling. As the stop tightens, size grows without limit.
On a $10,000 cash account buying a $100 stock:

| Stop distance | Risk (1%) | Units | Notional | × equity |
|---------------|-----------|-------|----------|----------|
| $5.00         | $100      | 20    | $2,000   | 0.2×     |
| $0.50         | $100      | 200   | $20,000  | 2.0×     |
| $0.22         | $100      | 460   | $46,000  | **4.6×** |

Every row risks exactly 1% to the stop, and the last row is impossible in a
cash account. A backtester that sizes this way without further checks will
happily report results for positions the account could never hold.

The lesson: **risk-per-trade tells you how much you want. Separate constraints
decide how much you're allowed.** Final size is the minimum of every
constraint, never the output of one formula.

## Vocabulary

| Term                              | Meaning                                                            |
|-----------------------------------|--------------------------------------------------------------------|
| **Equity / NAV**                  | Cash + unrealized P&L. The base for all percentages.               |
| **Balance**                       | Cash only. Don't size off it while positions are open.             |
| **Notional (exposure)**           | Units × price, in account currency. What you actually control.     |
| **Gross exposure**                | Σ \|notional\|. Longs and shorts both add.                         |
| **Net exposure**                  | Σ signed notional. Longs minus shorts.                             |
| **Leverage**                      | Gross exposure ÷ equity. A cash account is ≤ 1.0.                  |
| **Buying power**                  | Additional notional the account can open right now.                |
| **Initial margin**                | Collateral required to open a position.                            |
| **Maintenance margin**            | Collateral required to keep it open.                               |
| **Margin utilization**            | Margin used ÷ equity.                                              |
| **Margin closeout / liquidation** | Broker force-closes positions when equity falls below a threshold. |
| **Trade risk (R)**                | Loss if the stop is hit: units × \|entry − stop\| + costs.         |
| **Portfolio heat**                | Σ R across open trades. What you lose if every stop hits.          |
| **High-water mark (HWM)**         | Highest equity reached.                                            |
| **Drawdown**                      | (HWM − equity) ÷ HWM.                                              |
| **Circuit breaker / kill switch** | Rule that halts new entries or flattens after a loss threshold.    |
| **Correlation bucket**            | Positions that behave as one bet, such as several USD-short pairs. |
| **Gap risk**                      | Loss beyond the stop when price jumps past it.                     |
| **Pre-trade risk check**          | Gate every order passes before submission. Rejects or resizes.     |

The pair most often confused is **heat** and **exposure**. You need limits on
both. A heat limit alone allows the 4.6× case above. An exposure limit alone
lets wide-stop trades quietly risk too much.

## The math behind small risk numbers

### Losing streaks happen

For a system with loss probability *p*, the expected longest losing streak over
*N* trades is roughly:

```
longestStreak ≈ ln(N) / ln(1/p)
```

| Win rate | Loss rate | Expected longest streak in 100 trades |
|----------|-----------|---------------------------------------|
| 55%      | 45%       | ~6                                    |
| 45%      | 55%       | ~8                                    |
| 40%      | 60%       | ~9                                    |

Plan for a streak somewhat longer than the expected one, because it's an
average, not a maximum.

### What a streak costs at different risk levels

Equity after *k* consecutive losses risking *r* each is `(1 − r)^k`.

| Risk per trade | 5 losses | 10 losses | 15 losses |
|----------------|----------|-----------|-----------|
| 0.5%           | −2.5%    | −4.9%     | −7.2%     |
| 1%             | −4.9%    | −9.6%     | −14.0%    |
| 2%             | −9.6%    | −18.3%    | −26.1%    |
| 5%             | −22.6%   | −40.1%    | −53.7%    |

### Recovery is asymmetric

A drawdown of *d* requires a gain of `d / (1 − d)` to get back to even.

| Drawdown | Gain needed to recover |
|----------|------------------------|
| 5%       | 5.3%                   |
| 10%      | 11.1%                  |
| 20%      | 25.0%                  |
| 30%      | 42.9%                  |
| 50%      | 100.0%                 |

Together, these tables explain why swing systems usually keep risk per trade in
the 0.5–1% range. A 10-trade losing streak at 1% is an unpleasant month. At 5%
it's a 40% hole that needs a 67% gain to fill.

## The layered model

Each layer can only reduce size or reject the trade. No layer can increase what
an earlier layer set.

```
signal
  │
  ▼
[1] Sizing intent        risk-per-trade → desired units
  │
  ▼
[2] Account constraints  buying power / margin for this market type
  │
  ▼
[3] Position limits      max notional per position, lot rounding
  │
  ▼
[4] Portfolio limits     heat, gross exposure, correlation, max positions
  │
  ▼
[5] Account state gates  drawdown ladder, daily/weekly loss limits
  │
  ▼
order
  │
  ▼
[6] Post-trade monitor   margin utilization, closeout distance, HWM
```

### 1. Sizing intent

```
riskAmount   = equity × riskPerTrade × sizeMultiplier   // multiplier from layer 5
perUnitRisk  = |entry − stop| + expectedSlippage + perUnitCost
desiredUnits = riskAmount / perUnitRisk
```

- **Convert to account currency.** In forex, stop distance is in the quote
  currency. Skipping the pip-value conversion silently mis-sizes JPY pairs and
  crosses.
- **Enforce a minimum stop distance**, for example half an ATR. Stops inside
  normal noise both oversize the position and get hit anyway.
- **Use gap-adjusted risk** for instruments that gap: `max(stopDistance,
  gapFactor × ATR)`. A stop is an order, not a guarantee.

### 2. Account constraints

```
maxUnitsByMargin = availableBuyingPower / (price × marginRate)
```

`marginRate` is 1.0 for a cash account. Available buying power has to account
for every open position and every pending order. When multiple strategies or
instruments share one account, buying power must be reserved at the moment an
order is approved, or several simultaneous signals will each size against the
whole account.

### 3. Position limits

- Cap any single position at a percentage of equity.
- Set an absolute maximum order size as a fat-finger guard.
- Round **down** to the broker's lot size. If that produces zero, reject rather
  than rounding up to the minimum.
- For thinly traded instruments, cap size at a fraction of average daily volume.

### 4. Portfolio limits

- **Maximum portfolio heat**: total R across open trades.
- **Maximum gross leverage**: set well below what the broker allows.
- **Maximum open positions.**
- **Correlation buckets**: cap heat per bucket. In forex, break each pair into
  per-currency exposure (long EUR/USD is +EUR, −USD) and cap net exposure per
  currency. Trading EUR/USD and GBP/USD long at 0.5% each is closer to one 1%
  USD-short trade than to two independent ones.

When a new trade would breach a portfolio limit, either reject it or shrink it
to fit. A reasonable policy is shrink-to-fit with a floor: if the trade would be
less than about a quarter of its intended size, skip it. A sliver of a trade is
not what the strategy signaled.

### 5. Account state gates

A drawdown ladder measured from the high-water mark, plus shorter-horizon loss
limits:

| State       | Trigger (example) | Effect                                    |
|-------------|-------------------|-------------------------------------------|
| Normal      | Drawdown < 5%     | Full size                                 |
| Caution     | Drawdown ≥ 5%     | Half size                                 |
| Halted      | Drawdown ≥ 10%    | No new entries; manage existing positions |
| Flatten     | Drawdown ≥ 15%    | Close everything                          |
| Daily stop  | Day P&L ≤ −2%     | No new entries until next session         |
| Weekly stop | Week P&L ≤ −4%    | No new entries until next week            |

Three design rules matter more than the exact numbers:

- **Halts don't resume on their own.** Recovering above the threshold should not
  silently restart trading. Require a deliberate decision to rearm.
- **Measure with equity, not balance.** Otherwise a large losing open position
  hides the drawdown until it closes.
- **Define the session boundary once**, such as 5 p.m. New York for forex, so
  "daily" means the same thing everywhere.

### 6. Post-trade monitoring

- Recompute margin utilization and distance to broker closeout on every price
  update.
- Above a utilization threshold, block new entries.
- As closeout approaches, reduce positions yourself, largest risk first, rather
  than letting the broker pick what to liquidate.
- Update the high-water mark and drawdown state.

## How margin works by market

Assume one market type per account, since the rules differ enough that mixing
them in one sizing model causes errors.

### Cash equities

- Buying power is settled cash minus cash committed to pending orders.
- Leverage is at most 1.0, and there's no shorting.
- US equities settle T+1. Reusing unsettled sale proceeds too quickly can cause
  good-faith violations in a real cash account.

### Margin equities (Reg T)

- Initial margin is 50%, giving 2× overnight buying power. Maintenance is at
  least 25% under FINRA rules and often 30% or more at the broker, higher for
  volatile names.
- The pattern-day-trader rule has historically required $25,000 for frequent
  intraday round trips. FINRA has been revising it, so check the current rule.

### Forex

- Margin is set per instrument. US retail limits are 50:1 on major pairs (2%
  margin) and 20:1 on others (5%). Brokers publish the exact rate per
  instrument.
- Brokers close out positions when equity falls to a set fraction of margin
  used; at OANDA, for example, that's half.
- Trading is continuous during the week, but the weekend is a real gap.
- Overnight financing (swap) accrues daily and belongs in any backtest.

### Futures

- Margin is a fixed dollar amount per contract, set by the exchange with
  possible broker add-ons.
- Contract notional is large, so whole-contract rounding dominates at small
  account sizes. Sometimes the correct answer is that the account is too small
  for the contract.
- Positions are marked to market daily, and contracts must be rolled before
  expiry.

### Crypto

- **Spot** behaves like cash equities, but trades around the clock with no
  settlement delay.
- **Perpetuals and margin products** have per-position maintenance margin, a
  liquidation price, and periodic funding payments. Liquidation is typically
  faster and less forgiving than a forex closeout.

## Parameters worth defining

These defaults are conservative starting points for swing trading, not
recommendations. Percentages are of equity unless noted.

### Per trade

| Parameter             | Starting point           | Notes                                        |
|-----------------------|--------------------------|----------------------------------------------|
| Risk per trade        | 0.5%                     | 1% is a common upper bound for swing systems |
| Minimum stop          | 0.5 × ATR                | Widen or reject tighter stops                |
| Gap risk floor        | 1.0 × ATR                | For gap-prone instruments                    |
| Max position notional | 25% equities, 100% forex | Per position                                 |
| Max order size        | Fixed dollar amount      | Fat-finger guard                             |
| Minimum fill fraction | 25%                      | Skip trades shrunk below this                |

### Portfolio

| Parameter                       | Starting point              | Notes                    |
|---------------------------------|-----------------------------|--------------------------|
| Max portfolio heat              | 4%                          | Total risk to stops      |
| Max gross leverage              | 1.0 cash equities, 5× forex | Well under broker limits |
| Max open positions              | 6                           |                          |
| Max heat per correlation bucket | 1.5%                        |                          |
| Max net exposure per currency   | 2× equity                   | Forex                    |

### Margin

| Parameter                  | Starting point | Notes                                   |
|----------------------------|----------------|-----------------------------------------|
| Margin utilization warning | 30%            | Block new entries above this            |
| Closeout buffer            | 50%            | Self-reduce well before the broker does |
| Cash reserve               | 5%             | Never committed                         |

### Account state

| Parameter                          | Starting point |
|------------------------------------|----------------|
| Caution drawdown / size multiplier | 5% / 0.5       |
| Halt drawdown                      | 10%            |
| Flatten drawdown                   | 15% (optional) |
| Daily loss limit                   | 2%             |
| Weekly loss limit                  | 4%             |
| Rearm                              | Manual         |

### Operational

| Parameter                     | Notes                               |
|-------------------------------|-------------------------------------|
| Max orders per minute         | Runaway-loop protection             |
| Max price age                 | Don't size off stale quotes         |
| Slippage and commission model | Per market, for realistic backtests |

In practice only a few of these get tuned regularly: risk per trade, max heat,
and the drawdown thresholds. The rest should have sensible defaults that rarely
change.

## Easy-to-miss risks

- **A stop isn't a maximum loss.** Gaps make portfolio heat an underestimate. A
  useful stress figure is the loss if every position gaps two ATRs against you.
- **Correlations rise in a crisis.** Buckets built from calm-market correlations
  understate risk exactly when it matters. Simple, conservative fixed groupings
  often beat estimated correlation matrices.
- **Pending orders use buying power.** Reserve it when the order is placed and
  release it on cancel.
- **Stale data is a fat-finger in disguise.**
- **Everything must be in account currency**: P&L, risk, and margin.
- **Costs matter more than they look**, especially for strategies with small,
  bounded profit targets like mean reversion.
- **Reconcile with the broker.** Periodically compare your recorded positions
  and cash with the broker's and stop trading on a mismatch.
- **Log every rejection and resize** along with the constraint that caused it.
  Otherwise "why didn't it take that trade?" has no answer.

## Sanity checks for any backtester

Run these as invariants across every bar of every backtest:

1. On a cash account, gross exposure never exceeds equity.
2. Total risk to stops never exceeds the heat limit.
3. Several simultaneous signals never produce combined notional above buying
   power.
4. A very tight stop produces a position capped by buying power or the position
   limit, not an enormous one.
5. Positions in cross and JPY pairs risk the intended amount in account
   currency.
6. The drawdown ladder reduces size, then halts, and doesn't resume on its own.
7. Simulated margin closeouts follow the same rule the broker uses.

If a backtest can't pass these, its results describe a strategy no real account
could have run.

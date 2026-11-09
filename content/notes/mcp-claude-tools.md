---
title: "Build an MCP Server in Go: Expose Your App to Claude"
date: 2026-05-22
description: >
  Build an MCP server in Go with the official SDK: typed tools, structured
  output, a write gate, and safe errors, plus Claude Code setup and lessons
  from a production server.
categories: ["Go", "Developer Tools"]
tags: ["Go", "MCP", "Claude", "Claude Code", "AI Agents", "API Design"]
summary: "A working MCP server in Go with the official SDK, connected to Claude Code, and the patterns Trader's production MCP server uses to keep a model's access narrow and safe."
---

The Model Context Protocol (MCP) lets a model like Claude call tools that your
application defines. Instead of pasting data into a chat or writing one-off
scripts, you give the model a small set of typed operations, and it calls them
directly from Claude Code, Claude Desktop, or any MCP client.

This tutorial builds a minimal MCP server in Go with the official SDK, connects
it to Claude Code, and then looks at how
[Trader](/projects/trader/)'s production server applies the same ideas. The
example was built and exercised against
[`github.com/modelcontextprotocol/go-sdk`](https://github.com/modelcontextprotocol/go-sdk)
v1.8.0, and the Trader details come from its `trader-mcp` server at
[commit `3f8dd53`](https://github.com/rustyeddy/trader/tree/3f8dd531e562f9cb2c6bb5e80c560e81e35408c9/cmd/trader-mcp).

## Why This Matters

An MCP server is a boundary between a model and a real system. Everything the
model can do to that system goes through it. If the boundary is narrow,
typed, and safe by default, you can let an agent work against real data
without worrying about what it might do next. If it's a thin wrapper that
exposes everything, you've handed your system to whatever the model decides
to try.

That makes the server's design a delivery decision, not just a plumbing task.

## How MCP Works

MCP is JSON-RPC 2.0. For a local tool, the client starts your server as a
child process and talks to it over stdin and stdout. A session looks like
this:

1. `initialize`: client and server agree on a protocol version and exchange
   names and capabilities.
2. `tools/list`: the server returns each tool's name, description, input
   schema, and (optionally) output schema.
3. `tools/call`: the client calls a tool by name with JSON arguments, and the
   server returns a result.

MCP also defines resources (readable artifacts) and prompts (reusable
templates), but tools are where most of the value is.

The model never sees your code. It sees tool names, descriptions, and
schemas, and decides from those what to call. Writing them well is most of
the work.

## Build the Server

The official Go SDK does the protocol work. You write ordinary Go functions
with typed inputs and outputs. It requires Go 1.25 or later:

```bash
go get github.com/modelcontextprotocol/go-sdk@v1.8.0
```

Here is a complete server with two tools: a read-only `get_quote` and a
`set_quote` that changes data and is off unless the operator enables it.

```go
package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"log/slog"
	"os"
	"strings"
	"sync"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

// ErrWritesDisabled is safe to show the client: it names only the
// server's own policy.
var ErrWritesDisabled = errors.New("writes are disabled; restart the server with --allow-writes")

// store stands in for your application service. Handlers call it; they
// never contain business logic themselves.
type store struct {
	mu     sync.Mutex
	prices map[string]string
}

func (s *store) Get(symbol string) (string, bool) {
	s.mu.Lock()
	defer s.mu.Unlock()
	p, ok := s.prices[symbol]
	return p, ok
}

func (s *store) Set(symbol, price string) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.prices[symbol] = price
}

type QuoteInput struct {
	Symbol string `json:"symbol" jsonschema:"instrument symbol, for example EURUSD"`
}

type QuoteOutput struct {
	Symbol string `json:"symbol"`
	Price  string `json:"price" jsonschema:"exact decimal, as a string"`
}

type SetQuoteInput struct {
	Symbol string `json:"symbol" jsonschema:"instrument symbol, for example EURUSD"`
	Price  string `json:"price" jsonschema:"exact decimal, as a string"`
}

type server struct {
	store       *store
	allowWrites bool
	log         *slog.Logger
}

func (s *server) quote(ctx context.Context, _ *mcp.CallToolRequest, in QuoteInput) (*mcp.CallToolResult, QuoteOutput, error) {
	sym := strings.ToUpper(strings.TrimSpace(in.Symbol))
	price, ok := s.store.Get(sym)
	if !ok {
		return nil, QuoteOutput{}, fmt.Errorf("no quote for %q", sym)
	}
	return nil, QuoteOutput{Symbol: sym, Price: price}, nil
}

func (s *server) setQuote(ctx context.Context, _ *mcp.CallToolRequest, in SetQuoteInput) (*mcp.CallToolResult, QuoteOutput, error) {
	if !s.allowWrites {
		s.log.Warn("write tool refused", "tool", "set_quote")
		return nil, QuoteOutput{}, ErrWritesDisabled
	}
	sym := strings.ToUpper(strings.TrimSpace(in.Symbol))
	s.store.Set(sym, in.Price)
	return nil, QuoteOutput{Symbol: sym, Price: in.Price}, nil
}

func main() {
	allowWrites := flag.Bool("allow-writes", false, "enable data-changing tools")
	flag.Parse()

	// stdout carries the MCP protocol. Log to stderr only.
	log := slog.New(slog.NewTextHandler(os.Stderr, nil))

	s := &server{
		store:       &store{prices: map[string]string{"EURUSD": "1.08457"}},
		allowWrites: *allowWrites,
		log:         log,
	}

	srv := mcp.NewServer(&mcp.Implementation{Name: "quotes", Version: "v0.1.0"}, nil)
	mcp.AddTool(srv, &mcp.Tool{
		Name:        "get_quote",
		Description: "Return the last price for one symbol. Read-only.",
		Annotations: &mcp.ToolAnnotations{ReadOnlyHint: true},
	}, s.quote)
	mcp.AddTool(srv, &mcp.Tool{
		Name:        "set_quote",
		Description: "Set the price for one symbol. Requires a server started with --allow-writes.",
	}, s.setQuote)

	if err := srv.Run(context.Background(), &mcp.StdioTransport{}); err != nil {
		log.Error("server stopped", "err", err)
		os.Exit(1)
	}
}
```

A few things the SDK does for you are worth knowing, because they change how
you design tools.

### Schemas come from your types

`mcp.AddTool` is generic over the input and output types. The SDK builds the
JSON Schema from the struct and its `jsonschema` tags, and validates incoming
arguments against it before your handler runs. For `get_quote`, the client
receives:

```json
{
  "type": "object",
  "properties": {
    "symbol": {"type": "string", "description": "instrument symbol, for example EURUSD"}
  },
  "required": ["symbol"],
  "additionalProperties": false
}
```

Those tag descriptions are what the model reads. Treat them as documentation
for someone who has never seen your code.

### Output is structured

Because the handler returns a typed `QuoteOutput`, the SDK publishes an output
schema in `tools/list` and returns the result as structured JSON
(`structuredContent`), with a JSON text copy for clients that only read text:

```json
{"price": "1.08457", "symbol": "EURUSD"}
```

The price is a string on purpose. A JSON number would pass through a
floating-point value somewhere on its way to the model. See
[Money in Go](/software/numeric-types-financial-software/) for why that
matters.

### Errors are tool results, not crashes

When a handler returns an error, the SDK sends it back as a tool result
marked `isError`, with the error text as its content. The session keeps
going, and the model can read the message and adjust. Calling `get_quote`
for an unknown symbol returns `no quote for "GBPUSD"`. That means **every
error message you return is something the model, and possibly the user,
will see.** More on that below.

### Writes are off by default

Started normally, `set_quote` refuses and tells the operator how to enable
it:

```text
writes are disabled; restart the server with --allow-writes
```

The refusal is also logged to stderr. Started with `--allow-writes`, the same
call succeeds and a following `get_quote` returns the new price.

## Connect It to Claude Code

Build the binary, then register it with Claude Code. Everything after `--` is
the command Claude Code runs to start your server:

```bash
go build -o quotes .
claude mcp add --transport stdio quotes -- /path/to/quotes
```

To pass credentials, use `--env`, with another option such as
`--transport stdio` between it and the server name:

```bash
claude mcp add --env QUOTES_API_KEY=... --transport stdio quotes -- /path/to/quotes
```

By default a server is added at **local** scope: available in the current
project and stored in `~/.claude.json`. Use `--scope project` to share it with
your team through a `.mcp.json` file in the repository, or `--scope user` to
make it available in all of your projects.

A shared `.mcp.json` can reference environment variables so secrets stay out
of version control. Claude Code expands `${VAR}` and `${VAR:-default}` in
`command`, `args`, and `env`:

```json
{
  "mcpServers": {
    "quotes": {
      "type": "stdio",
      "command": "${QUOTES_BIN:-quotes}",
      "args": [],
      "env": {
        "QUOTES_API_KEY": "${QUOTES_API_KEY}"
      }
    }
  }
}
```

`claude mcp list` shows each server and whether Claude Code could connect to
it, and `/mcp` inside a session shows the same status. See the
[Claude Code MCP documentation](https://code.claude.com/docs/en/mcp) for the
full set of options.

## Patterns From a Production Server

The example is deliberately small. Trader's `trader-mcp` exposes seven tools
over its market data and backtesting services, and its design is recorded in
architecture decision records ADR-068 through ADR-070. A few of its choices
are worth copying.

### Keep the adapter thin

Every Trader tool handler does the same three things: parse the request with
the service layer's own parsers, call one service operation, and translate
the result. Business logic stays in the services, which the CLI uses too. A
backtest run over MCP resolves its configuration through the same code path
as `trader backtest run`, so both entry points behave identically.

That's what keeps an MCP server maintainable. If logic creeps into handlers,
you end up with two implementations of every operation that drift apart.

### Make writes an operator decision

Trader's read-only tools (`trader_version`, `trader_instruments`,
`trader_marketdata_coverage`, `trader_run_backtest`, and
`trader_backtest_result`) are always available. The tools that change data
(`trader_marketdata_update` and `trader_marketdata_canonicalize`) refuse
unless the server was started with `--allow-writes` or
`TRADER_MCP_ALLOW_WRITES=true`:

```text
trader_marketdata_update: data-mutating tools are disabled on this server;
restart trader-mcp with --allow-writes (or TRADER_MCP_ALLOW_WRITES=true)
```

Trader still *lists* the write tools on a read-only server. The model learns
the capability exists, and a refused call produces a message the person can
act on. The alternative, registering write tools only when writes are enabled,
hides them completely. Either is defensible; what matters is that the default
is safe and enabling writes is an explicit decision by a person, not by the
model.

### Decide what errors a client may see

Because errors flow back to the model, Trader routes every error through one
function. Errors built only from the caller's own input (a bad symbol, an
invalid date, an unknown provider) or from the server's own policy pass
through verbatim. Anything else, such as storage, I/O, or configuration
failures whose messages might contain file paths, collapses to a fixed
message like `backtest failed; see the trader-mcp server log`, and the full
error is logged on the server side.

The rule from ADR-068: MCP never exposes filesystem layout or composition
internals. Make that an allowlist in code, not a habit.

### Keep stdout clean and secrets out

On the stdio transport, stdout *is* the protocol. A stray log line corrupts
the session. Trader logs to stderr by default and refuses to start if logging
is pointed at stdout. Credentials for its market-data providers (OANDA,
Alpaca) come only from environment variables, never from flags, and are never
logged or returned.

### Bound what a tool returns

A backtest report can be large: equity curves, every trade. So
`trader_run_backtest` returns a run ID and a summary only, and
`trader_backtest_result` fetches the full stored report by run ID when it's
actually needed. When the client asks for progress updates, a run also
reports each stage as it finishes.

Large tool results fill the model's context with data it may not need.
Return summaries by default and offer a second tool for detail.

## What Makes a Good MCP Tool

- **One responsibility per tool.** Narrow tools are easier for the model to
  choose correctly and easier for you to secure.
- **Descriptions that say when to use the tool**, not just what it does.
  Trader's coverage tool says it is read-only, never converts or downloads,
  never returns bars, and returns one result per symbol. That tells the model
  exactly what to expect.
- **Typed, structured output.** Return a struct, let the SDK publish the
  schema, and keep exact values (prices, money) as strings.
- **Annotations.** `ReadOnlyHint` and related hints tell clients which tools
  are safe to call freely. They are hints, not enforcement; the write gate is
  the enforcement.
- **Errors written for the reader.** Say what went wrong and what to do about
  it, using only information that is safe to show.

## A Note on OANDA

An earlier version of this article described a Trader MCP server that wrapped
an OANDA account directly, including order placement behind a write flag. The
current server is narrower by design: it uses OANDA (and Alpaca and Stooq) as
market-data providers for research and backtesting, and does not place
orders. If you're looking for an OANDA account MCP server, several community
implementations exist; the patterns above apply to evaluating them as much as
to writing your own.

## Where This Fits

- [Trader: FX Backtesting and Live Trading Engine](/projects/trader/) is the
  project behind the examples.
- [Money in Go](/software/numeric-types-financial-software/) explains why
  prices travel as strings.
- [Writing Agent Instructions for a New Software Project](/software/writing-agent-instructions/)
  covers the other half of working with agents: telling them how your
  project works.

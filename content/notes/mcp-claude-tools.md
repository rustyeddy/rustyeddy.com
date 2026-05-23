---
title: Exposing a Go App as Claude MCP Tools
date: 2026-05-22
description: >
  How to implement an MCP server in Go that exposes application functions
  as typed tools for Claude Code and Claude Desktop — with a working example
  from the Trader FX engine.
---

The Model Context Protocol (MCP) lets Claude call external tools defined by
your application. Instead of pasting data into a chat window or writing one-off
scripts to query your system, you define tools with typed schemas, start an
MCP server, and Claude can call them directly — in Claude Code, Claude Desktop,
or any MCP-compatible client.

The [Trader](https://github.com/rustyeddy/trader) project uses this to expose
its Forex trading engine as Claude tools: query your OANDA account, review open
trades, run a backtest against historical data, and — when explicitly enabled —
place or close orders.

## How MCP Works

MCP is JSON-RPC 2.0 over stdio. The client (Claude) sends requests; the server
(your app) responds. The protocol defines a small set of methods:

- `initialize` — handshake, agree on protocol version
- `tools/list` — return the list of available tools with their input schemas
- `tools/call` — call a named tool with provided arguments
- `resources/list`, `resources/read` — expose readable artifacts (files, reports)
- `prompts/list` — expose reusable prompt templates

Claude uses the tool descriptions and schemas to decide which tool to call and
how to format the arguments. Clear descriptions and precise schemas produce
better results than vague ones.

## Server Structure

Trader's MCP server lives in `api/mcp/` and is split across three files:

**`server.go`** — the dispatcher. It reads from stdin, parses JSON-RPC
requests, and routes to the appropriate handler. Notifications (requests
without an `id`) are handled separately and never replied to, per the
JSON-RPC spec.

```go
func (s *Server) handleRequest(req *Request) *Response {
    switch req.Method {
    case "initialize":
        return s.handleInitialize(req)
    case "tools/list":
        return s.handleToolsList(req)
    case "tools/call":
        return s.handleToolsCall(req)
    case "resources/list":
        return s.handleResourcesList(req)
    case "resources/read":
        return s.handleResourcesRead(req)
    }
    return errorResponse(req.ID, -32601, "method not found")
}
```

**`tools.go`** — tool definitions and handlers. Each tool has a name,
description, and a JSON Schema for its input parameters. The description
is what Claude reads to decide when to call the tool — write it like
documentation for a human who knows nothing about your internals.

**`resources.go`** — exposes readable artifacts. Trader uses this for
backtest `.org` report files and YAML config files, letting Claude read
past results or configs without a separate tool call.

## Defining a Tool

A read-only tool looks like this:

```go
Tool{
    Name: "run_backtest",
    Description: "Run a backtest using a named YAML config file. " +
        "Returns a summary including net P/L, win rate, trade count, " +
        "and max drawdown. Does not require OANDA credentials.",
    InputSchema: map[string]any{
        "type": "object",
        "properties": map[string]any{
            "config": map[string]any{
                "type":        "string",
                "description": "Path to the YAML config file, relative to testdata/configs/",
            },
        },
        "required": []string{"config"},
    },
},
```

The handler calls the actual backtest logic and returns the result as a
string. Claude receives it and can reason over it, compare it to other runs,
or present a summary.

## Write-Gating

Write tools — `place_order`, `close_trade`, `update_stop` — are only
registered when the server is started with `--enable-write`:

```go
func (s *Server) buildTools() []Tool {
    tools := readOnlyTools()
    if s.EnableWrite {
        tools = append(tools, writeTools()...)
    }
    return tools
}
```

This means the default MCP session is read-only. You can query your account
balance, review positions, and run backtests without any risk of accidental
order placement. When you actually want to trade, you restart with
`--enable-write` and Claude knows the write tools are available.

The pattern is worth adopting for any MCP server that has side effects: split
tools into read and write, gate the writes explicitly, and make the default
safe.

## Transport

Stdio is the standard MCP transport for local tools. The server reads a
line from stdin, processes it, writes a line to stdout. This makes it trivial
to test outside Claude:

```bash
echo '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}' | trader mcp
```

It also means the server has no network exposure by default — it only
communicates with the process that spawned it, which is the MCP client.

## Connecting to Claude Code

Add the server to `.claude/settings.json` or the global Claude Code config:

```json
{
  "mcpServers": {
    "trader": {
      "command": "trader",
      "args": ["mcp"],
      "env": {
        "OANDA_TOKEN": "${OANDA_TOKEN}"
      }
    }
  }
}
```

Once connected, Claude Code can call `run_backtest`, `get_account_summary`,
and the other tools in any conversation. You can ask "which of my configs
has the best Sharpe ratio?" and Claude will call `run_backtest` for each
config and compare the results.

## What Makes a Good MCP Tool

A few things that improve tool quality in practice:

**One responsibility per tool.** `get_account_summary` returns account state.
`list_open_trades` returns positions. Combining them into one tool makes the
response harder for Claude to parse and reason over.

**Descriptions that explain when to call the tool, not just what it does.**
"Returns account balance" is less useful than "Returns current balance, NAV,
margin used, and unrealized P/L. Call this before placing an order to verify
available margin."

**Return structured data as formatted text.** Claude handles plain text and
markdown better than raw JSON in tool responses. Format numbers, add labels,
and use tables for lists of items.

**Fail with useful error messages.** If OANDA is not configured and a tool
requires it, return an error response explaining that — not a Go panic or a
blank response.

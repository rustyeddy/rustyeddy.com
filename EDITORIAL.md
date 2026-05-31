# Editorial Guide and Existing Content Backlog

This document is the working editorial guide for RustyEddy.com and the edit queue for existing published content that still needs attention.

The backlog below is intentionally limited to content that already exists on the site. When an article is finished, demoted, merged, archived, or drafted, remove it from this document. New content ideas should be tracked somewhere else later.

## Editorial Direction

RustyEddy.com should read like a practical engineering notebook that has been cleaned up for other engineers.

The voice should be:

- Practical: explain what works, what breaks, and why it matters.
- Architecture-first: show boundaries, responsibilities, and tradeoffs.
- Decision-oriented: help the reader choose a design, pattern, tool, or next step.
- Project-grounded: use OttO, Trader, RedEye, and the garden system as concrete examples.
- Plainspoken: avoid marketing phrasing, vague claims, and generic introductions.

Avoid:

- "This article will explore..."
- Unsupported claims like "robust," "scalable," or "enterprise-grade."
- AI-sounding second-person product copy.
- Long historical digressions before the engineering problem is clear.
- Publishing visible TODOs, localhost links, merge conflict markers, or draft notes.

## Content Types

Use these labels when deciding what a page should become.

**Pillar**

Long-lived architecture or process pages that explain a major system or design pattern.

Examples: IoT system architecture, IoT device abstraction layer in Go, SDLC for small teams, edge gateway architecture.

**Case Study**

Project-grounded explanations that show architecture in context.

Examples: self-watering garden, OttO edge runtime, Trader backtesting engine, RedEye video network.

**Supporting Article**

Focused implementation or process content that supports a pillar or case study.

Examples: MQTT gateway design, REST gateway API design, Kanban, version control.

**Note**

Small observations, experiments, setup notes, and implementation fragments.

Notes can be rougher than articles, but they must not be broken. Notes with TODOs should usually become drafts until repaired.

## Disposition Labels

Every backlog item should have one disposition:

- **Promote**: strong enough to become pillar or near-pillar content after polish.
- **Improve**: worth keeping public, but needs rewrite, structure, or cleanup.
- **Merge**: useful material, but should be folded into a stronger page.
- **Archive as note**: historically useful, but not canonical.
- **Draft/hide**: not publication-ready or not aligned with the current site.

## Article Quality Checklist

Use this before updating, republishing, or promoting an article.

### Reader and Promise

- [ ] The opening identifies the reader or situation.
- [ ] The article states the engineering problem being solved.
- [ ] The article promises a concrete decision, design, or pattern the reader will understand by the end.
- [ ] The introduction is specific, not generic.

### Architecture and Tradeoffs

- [ ] The article explains boundaries between components.
- [ ] It distinguishes device, edge, backend, API, storage, UI, and operations concerns where relevant.
- [ ] It explains why the design is useful, not only how it works.
- [ ] It names tradeoffs and alternatives.
- [ ] It includes a diagram or ASCII sketch when structure matters.

### Practical Value

- [ ] Pillar and near-pillar pages include a `## Why this matters` section.
- [ ] Operational consequences are concrete.
- [ ] The article explains what becomes easier: testing, replacement, observability, deployment, debugging, scaling, or collaboration.
- [ ] Claims such as "robust" or "scalable" are backed by a mechanism.

### Common Pitfalls

- [ ] Add a `## Common pitfalls` section where appropriate.
- [ ] Pitfalls are specific to the article topic.
- [ ] Pitfalls include consequences: what breaks, becomes expensive, or becomes hard to maintain.

### Correctness and Currency

- [ ] Code snippets compile or are clearly labeled as pseudocode.
- [ ] Project names and architecture names are consistent.
- [ ] Current tools, APIs, libraries, protocols, and products are verified when likely to change.
- [ ] The article distinguishes implemented behavior from roadmap ideas.
- [ ] GitHub links point at current repos and active code when available.

### Publication Quality

- [ ] No visible TODOs, merge conflict markers, localhost links, or draft notes.
- [ ] No duplicate H1 caused by front matter plus Markdown title.
- [ ] Title and description are typo-free.
- [ ] Paragraphs are tight and skimmable.
- [ ] Headings are descriptive.
- [ ] Long code blocks are trimmed to what teaches the point.

### Linking and Metadata

- [ ] Link to the relevant pillar page near the top when one exists.
- [ ] Link to supporting articles where the reader naturally needs the next detail.
- [ ] Use descriptive anchors such as `device abstraction layer`, `IoT edge gateway`, `Go interfaces`, or `MQTT topic design`.
- [ ] Avoid anchors like `here`, `this`, or `read more`.
- [ ] Front matter is complete and consistent.
- [ ] Description is useful and roughly 140-160 characters.

## Priority Framework

Work in this order:

1. **Trust issues**: TODOs, broken prose, stubs, merge conflicts, incorrect claims.
2. **High-navigation pages**: pages linked from homepage, section indexes, or related reading.
3. **Pillar content**: IoT architecture, OttO/device manager, SDLC/software process, Go/Linux systems.
4. **Supporting content**: notes and older posts that reinforce pillars.
5. **Archive cleanup**: older notes that are useful as history but should not compete with polished content.

## Current Editorial Sprints

### Sprint 1: Publication Trust and Main Flow

### Sprint 2: IoT Cornerstone Content

- [ ] Rewrite `content/iot/iot-edge-gateway.md` as an architecture article.

### Sprint 3: Software Section Finish

- [ ] Rewrite `content/software/test-driven-software-development.md`.
- [ ] Rewrite `content/software/peer-review.md`.
- [ ] Rewrite `content/software/release-process.md`.
- [ ] Rewrite or merge `content/software/wireframes-and-storyboards.md`.

### Sprint 4: Promote Strong Technical Notes

- [ ] Promote or polish `content/notes/mcp-claude-tools.md`.
- [ ] Promote `content/software/numeric-types-financial-software.md`.
- [ ] Promote `content/software/strategy-pattern-backtesting.md`.
- [ ] Improve `content/notes/go-timers-testing-mqtt.md`.

## Existing Content Backlog

### Priority 0: Fix or Demote Raw Public Notes

### Priority 1: Strengthen Cornerstone IoT Content

### Priority 2: Modernize Older IoT Implementation Posts

### Priority 3: Finish the Software Section Refresh

#### Strategy Pattern in a Backtesting Engine

- **Path:** `content/software/strategy-pattern-backtesting.md`
- **Disposition:** Promote as strong standalone technical content.

Tasks:

- [ ] Add `Why this matters` heading explicitly.
- [ ] Add `Common pitfalls`: strategy calls broker directly, live/backtest divergence, untestable strategy state, context abuse.
- [ ] Link to Numeric Types and the Trader project.

### Priority 4: Improve High-Value Notes

#### Exposing a Go App as Claude MCP Tools

- **Path:** `content/notes/mcp-claude-tools.md`
- **Disposition:** Promote after polish.

Tasks:

- [ ] Add an architecture diagram: Claude client -> stdio -> MCP server -> Trader engine.
- [ ] Add `Why this matters`: typed tool boundary instead of ad hoc scripts.
- [ ] Add `Common pitfalls`: unsafe write tools, vague schemas, raw JSON dumps, side effects without explicit gating.
- [ ] Add a final checklist for MCP tool design.
- [ ] Verify protocol/client details before republishing because MCP tooling is moving quickly.

#### Go Timers for MQTT Testing

- **Path:** `content/notes/go-timers-testing-mqtt.md`
- **Disposition:** Improve or merge into MQTT gateway testing content.

Tasks:

- [ ] Update code style and naming.
- [ ] Clarify test pattern: callback -> channel -> select timeout.
- [ ] Add pitfalls: flaky timeouts, unbuffered channel deadlocks, broker lifecycle, test isolation.
- [ ] Link to MQTT gateway and TDD.

Suggested title: `Testing MQTT Publish/Subscribe in Go with Channels and Timeouts`

#### Simple Go Configuration

- **Path:** `content/notes/go-configuration.md`
- **Disposition:** Rewrite or archive.

Tasks:

- [ ] Decide whether this reflects current practice.
- [ ] If kept, show modern Go config boundaries: flags, env vars, config files, defaults, validation.
- [ ] Tie it to IoT gateway configuration.

Suggested title: `Configuration Boundaries in Small Go Services`

## Maintenance Rules

- Remove a backlog item when its disposition is complete.
- Keep this file limited to existing content on the site.
- Do not add new article ideas here.
- If an item becomes implementation work, create a GitHub issue and link it from the relevant backlog item.
- Review this file after each editorial sprint and delete completed entries aggressively.

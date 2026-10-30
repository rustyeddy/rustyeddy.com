# SEO and Content Planning Guide

> Status: draft for editorial review. Companion to [styleguide.md](styleguide.md).
> Research tracking: [rustyeddy.com issue #186](https://github.com/rustyeddy/rustyeddy.com/issues/186).
>
> Sources: October 2026 Search Console baseline and the external
> "Search Engine Optimization & Software Portfolio Strategy" review.
> Treat observed performance as historical, and projections as hypotheses.

## Purpose

Help engineers discover useful, accurate content at RustyEddy.com. Search optimization supports
the reader; it does not determine what we publish. The site's advantage is original engineering
experience, architecture decisions, source code, tests, and practical tradeoffs.

## Editorial positioning

Audience, thesis, pillars, and content tests are owned by
[`POSITIONING.md`](../POSITIONING.md). This guide covers process: how
to research, brief, review, and measure content. If the two disagree,
`POSITIONING.md` wins.

In short, the pillars are:

1. **Delivering software with AI:** Requirements → issues → agent delegation → PRs → independent
   review → CI → release. Explain where human architectural oversight is essential.
2. **Systems architecture for the real world:** Go domain models, interfaces, service boundaries,
   failure modes, testing, reproducibility.
3. **Building AI systems:** MCP servers, agents, tool design.

Trader, OttO/Gardener, and RedEye are *proof*, not pillars: case studies that support the
pillars. Trader is an engineering case study, not a trading-tips pivot.

Keep IoT, robotics, and networking content that demonstrably earns clicks or serves as proof
for a pillar (e.g. the Raspberry Pi motor-controller notes). Generic textbook topics ranking
below page 3 (e.g. "what is a multicast IP address", "5 layers of IoT") are merge or noindex
candidates; the content tracker records each decision.

## Reader personas (working hypotheses)

**Morgan — AI-enabled technical lead (primary).** Engineering manager, tech lead, technical
founder, or small-company CTO. Owns delivery outcomes. Wants a controlled, repeatable way to work
with AI coding agents without compromising architecture, tests, review, or accountability.
Example question: "How do I use GitHub issues and independent AI review to deliver reliable code?"

**Alex — experienced systems engineer (secondary).** Wants real architecture, working code,
failure modes, testability, and tradeoffs; already knows programming fundamentals. Served mainly
by the engineering notebook (`notes/`, implementation-level `software/`). Example question:
"How should I separate a strategy, data pipeline, and execution service in Go?"

Validate these personas against actual reader and search data. Articles can serve both, but name
one primary persona in the brief.

## Research workflow

1. **Baseline:** Capture Search Console date range, clicks, impressions, CTR and average position.
   Analyze both Queries and Pages. Export page-filtered queries when investigating a specific URL.
   Keep analytics and Search Console distinct; verify instrumentation before interpreting missing data.
2. **Find opportunities:** Identify pages with relevant impressions, useful queries and rankings
   within improvement range. Do not treat average position as a fixed rank; query/device variation matters.
3. **Discover strategic topics:** Include new pillars without existing impressions (AI agents,
   architecture, Trader). Absence of data on unpublished topics is not evidence of low demand.
4. **Examine search intent:** For each proposed topic, inspect current results, identify the user's
   job-to-be-done, likely format, and missing practical detail. Distinguish informational,
   how-to, navigational and commercial intent.
5. **Map one primary intent to one canonical page:** Prefer improving a suitable existing article
   before creating near-duplicates. Record target URL and related hub/project links.
6. **Prioritize:** Balance strategic fit, potential reader value, demonstrated visibility,
   competitive difficulty, engineering evidence available, and effort. Search volume alone is insufficient.
7. **Measure:** Record publication/update date, baseline and later Search Console performance.
   Attribute gains cautiously; rankings and CTR fluctuate.

### Research worksheet fields

Keyword/query | Intent | Persona | Pillar | Target URL | Existing/new | Impressions |
Clicks | CTR | Avg position | Competition notes | Evidence/source | Priority | Date reviewed.

## Article content brief — required before a substantial draft

- **Reader:** Primary persona and their technical starting point.
- **Problem:** What decision or task is the reader trying to complete?
- **Outcome:** What should they know, decide or implement afterward?
- **Search intent:** Primary query/topic and related terms, with supporting evidence or
  a clear "hypothesis" label.
- **Existing coverage:** Related pages to update/link; avoid content duplication.
- **Original contribution:** Project implementation, ADR, benchmark, experiment, failure mode,
  or genuine experience readers cannot get from a generic explanation.
- **Evidence:** Exact code paths/commits/issues, test output and external references to verify.
- **Outline:** Problem → constraints → design and tradeoffs → evidence/examples → lessons.
- **Assets:** Useful diagrams, screenshots and their accessible descriptions.
- **Acceptance criteria:** Factual checks, snippet tests, internal links, metadata, and Hugo build.
- **Owner/reviewer:** Who is drafting, independently reviewing and approving publication.

Never invent code, performance measurements, project features, engineering experience, educational
credentials, employment roles, or quotations. Attribute claims to actual evidence.

## On-page editorial SEO checklist

- [ ] Title accurately reflects the article and search intent; avoid clickbait.
- [ ] One clear H1 and descriptive, logical H2/H3 headings.
- [ ] Opening explains the engineering problem and reader value quickly.
- [ ] Content answers the query with original details, constraints and tradeoffs.
- [ ] Terminology and related search phrases appear naturally; no keyword stuffing.
- [ ] Meta title and description are accurate, distinct, and useful (Google may rewrite snippets).
- [ ] URL is stable and descriptive; do not change established URLs casually.
- [ ] Relevant internal links point to hub, project and related articles with meaningful anchor text.
- [ ] External citations and GitHub code references resolve and support the claims.
- [ ] Code snippets match the actual implementation and are tested when practical.
- [ ] Diagrams/images contribute understanding, use descriptive alt text and load efficiently.
- [ ] Dates indicate genuine publication or substantive updates, not cosmetic freshness.
- [ ] Technical reviewer verifies claims; editor checks against [styleguide.md](styleguide.md).

## Technical SEO and site UX checklist

- [ ] Check Search Console property, submitted XML sitemap and index coverage.
- [ ] Serve a canonical HTTPS URL; verify HTTP and alternate hostname redirects.
- [ ] Review self-referencing canonical links and redirect chains.
- [ ] Preserve inbound links when correcting old permalinks: use tested permanent redirects
      before updating canonical targets and internal links.
- [ ] Validate page title/description, Open Graph previews and appropriate JSON-LD.
- [ ] Use `Person` only with verified biographical information; `TechArticle`/`BlogPosting`
      on applicable articles; `SoftwareSourceCode` for accurate project documentation.
- [ ] Test Hugo generation, internal links, code highlighting, mobile layout, keyboard access,
      text contrast and image loading.
- [ ] Consider table of contents and code-copy affordances only if they improve usability.
- [ ] Avoid promising rich snippets, E-E-A-T boosts or ranking changes from markup alone.

## Topic clusters and navigation

- **Homepage:** Position the publication and route readers into architecture, AI-assisted
  delivery, and applied systems. Do not target every specific technical query.
- **/software/:** Engineering process and architecture, Go design, financial math, Trader lessons,
  and AI-assisted delivery where appropriate.
- **/iot/:** IoT/edge architecture, MQTT, devices and OttO.
- **/projects/trader/:** Verified system architecture and links to targeted software case studies.
- **Networking/notes:** Specialist reference material; link contextually to relevant hubs.

Avoid forced links and overclaiming "PageRank flow." Hub structure should primarily help
humans understand where to go next.

## Tracking: content tracker vs. GitHub issues

- **Content tracker (Google Sheet):** the triage view. One row per page with Search Console
  baseline, verdict (Keep / Update / Merge / Noindex / Delete / Publish / Review), priority,
  status, a link to the page's issue, and a Review tier (High = full review below).
- **GitHub issues:** work units for multi-step or multi-agent tasks. Each content page has a
  "Content cleanup" issue with the checklist: keyword research, edit content, import images.
- Deleting a stale draft or a one-line metadata change does not need its own issue workflow;
  mention the issue in the commit if one exists.
- PRs that do part of an issue's checklist say `Refs #N`. The PR that completes the checklist
  says `Closes #N`.

## Review and publishing workflow

**Planning → documented brief → technical draft → independent factual/technical review →
editorial/SEO review → assets/UX → Hugo/CI validation → human approval → publish → measurement.**

For typo fixes or minor metadata adjustments, use a lightweight PR. For new flagship
technical articles and High-tier reviews, use all stages. An AI writer must not self-certify
technical correctness.

In a multi-agent review, roles stay separate:

1. **Drafter** (any agent): keyword research from page-filtered Search Console queries, the
   edit, image/diagram proposals. Opens the PR.
2. **Independent reviewer** (a different model or a fresh agent without the drafter's context):
   checks facts, code, claims, and fit against `POSITIONING.md` and this guide. Comments on the PR.
3. **Rusty:** approves and merges. Nothing auto-merges.

## Current research backlog (not evergreen requirements)

The October 2026 external review proposed these *candidates*; verify the current site,
search intent, and measurements before opening implementation PRs:

- Review metadata on soil-sensor pages. (Numeric types, Raspberry Pi motor notes, MCP tools,
  and release process were retitled in #195.)
- `/notes/motor-controlor-notes/` keeps its misspelled URL: it is the site's top page, and
  GitHub Pages cannot issue true 301 redirects (Hugo aliases are meta-refresh pages).
- Audit HTTP/HTTPS canonicalization; reported duplicate schemes are a hypothesis to check.
- Explore Trader articles about strategy interfaces, numerical correctness, order state
  machines, reproducible backtests, and coordination of AI coding agents.
- Assess IoT MQTT/edge pages and LAN video/networking pages using page-filtered Search Console.
- Verify any proposed Trader performance figures through reproducible benchmarks.
- Do not use unsupported targets such as "+30% CTR," "rank top 3," or specified throughput
  as publication or acceptance promises.

Coordinate these with [issue #186](https://github.com/rustyeddy/rustyeddy.com/issues/186),
[homepage parent #96](https://github.com/rustyeddy/rustyeddy.com/issues/96), and the
existing **independent** article-review issues. Do not reparent or duplicate those issues.

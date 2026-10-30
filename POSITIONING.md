# Positioning Brief — rustyeddy.com

This is the single source of truth for who the site is for and what it
is trying to do. Every human or AI contributor (Claude, GPT, Gemini,
Codex) should read this before writing, editing, retitling, or pruning
content. `CLAUDE.md`, `AGENTS.md`, and `EDITORIAL.md` defer to it.

Last revised: 2026-10-29

## Thesis

AI makes code cheap. Delivering software that works in production is
still the hard part.

Rusty is a principal-level systems engineer (Rockwell space systems,
PIM multicast at USC/ISI, Cisco's Core Routing System, Panasonic
Avionics) who applies decades of shipping systems that could not fail
to AI-assisted software delivery.

The differentiator is not "AI expert." It is long experience with
reliability, architecture, and delivery discipline, now applied to
teams using LLMs and agents.

## Primary audience

People accountable for delivering software at small companies:

- Engineering managers
- Tech leads
- Technical founders
- CTOs of small companies (and the people one level down from them)

What they share: they own the outcome, their teams are adopting AI
tools faster than their process is adapting, and they need software
that survives production, not demos.

They read technical content, so articles may assume engineering
literacy. They do not need beginner explanations. They do need the
"so what": the decision, the risk, the tradeoff, and the cost of
getting it wrong.

## Secondary audience

Individual engineers leveling up toward lead/principal work, and
hiring managers evaluating Rusty. They are served by the engineering
notebook layer (deep technical notes, project write-ups, Go
implementation detail). That content stays, but it is supporting
material, not the front of the site.

## Out of scope

- Beginners and students (e.g. "what is a multicast IP address",
  "5 layers of IoT" textbook queries). Do not optimize for these.
- Hobbyist-only content with no link to delivery, architecture, or
  the reference projects.
- AI hype, tool roundups, and prompt-trick listicles.

## Goals, in order

1. Credibility with the primary audience.
2. Monetize: senior/principal roles and consulting engagements.
3. Sell the course (software delivery from idea to support, with AI
   woven throughout).

Single primary call to action across the site: **join the email
list.** Consulting and resume links are secondary.

## Pillars

| Pillar | Primary reader | Purpose |
|---|---|---|
| Delivering software with AI: lifecycle, agent instructions, verification, review, release | Leads, managers, founders | Core thesis; feeds the course |
| Systems architecture for the real world: boundaries, reliability, failure modes | Leads, engineers, hiring managers | Principal-engineer signal |
| Building AI systems: MCP servers, agents, tool design | Leads, engineers, consulting buyers | Demand and differentiation |

**Proof, not pillars:** Trader (trading systems), OttO / Gardener
(IoT and robotics), RedEye. These appear as case studies and
reference implementations that support the pillars.

**Engineering notebook:** `/notes/` and implementation-level
`/software/` articles (e.g. Go iterators in Trader, fixed-point money
types). Keep them; link them up to a pillar or project page.

## Content tests

Before publishing or keeping a page, it should pass at least one:

1. Would an engineering manager or technical founder learn something
   that changes a delivery, architecture, or AI-adoption decision?
2. Does it prove depth in one of the pillars or proof projects?
3. Does it serve the secondary audience and link up to a pillar?

A page that passes none is a candidate for merge, noindex, or removal.

## Open decisions

- Consulting: actively taking clients now, or "later"? Do not add a
  services page or hire-me CTA until decided.
- Course audience: currently designed for mid-career engineers; check
  fit against tech leads / new managers before the email sequence is
  finalized.
- Final wording of the thesis line on the homepage.

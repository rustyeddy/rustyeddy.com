# Content Overhaul Process

> How rustyeddy.com pages get triaged, rewritten, reviewed, shipped and
> measured. This is the runbook; [`seo-guide.md`](seo-guide.md) holds the
> research method and checklists, and [`POSITIONING.md`](../POSITIONING.md)
> decides what belongs on the site. If they disagree, `POSITIONING.md` wins.

## Where everything lives

| What | Where | Owns |
|---|---|---|
| Audience, thesis, pillars, content tests | `POSITIONING.md` | *Whether* a page belongs |
| Research method, briefs, SEO checklists | `knowledge/seo-guide.md` | *How* to research and review |
| Voice and quality checklist | `EDITORIAL.md`, `STYLEGUIDE.md` | *How it reads* |
| Repo mechanics (build, drafts, `noindex`, front matter) | `CLAUDE.md`, `AGENTS.md` | *How it ships* |
| **Content tracker** (Google Sheet) | [rustyeddy.com Content Tracker](https://docs.google.com/spreadsheets/d/1rIq_gzmZfugromdaUXW0gczdhPnEdIWhwGqPRhaJ3is/edit) | Per-page state: data, verdict, priority, status |
| Work units | GitHub issues, one "Content cleanup" issue per page | Multi-step or multi-agent tasks |
| Ground truth for search | Google Search Console, property `sc-domain:rustyeddy.com` | Impressions, clicks, position, queries |

The tracker is the single source of truth for page state. Do not keep a
second per-page backlog in a Markdown file; it will drift.

## The tracker

### Tab 1: pages (currently named "Untitled")

One row per file under `content/` (89 rows at the October 2026 baseline).
The header row is frozen, so the rows can be sorted freely.

| Column | Meaning |
|---|---|
| File path | Path in the repo, e.g. `content/software/kanban.md` |
| URL | Live URL |
| Title | Title at baseline (not updated after rewrites; see Notes) |
| Draft | `yes` if `draft: true` at baseline |
| Impressions (3 mo), Clicks, Avg position | Search Console baseline, 3 months ending 2026-10-11. **Never overwrite**: this is the "before" for measurement |
| Verdict | See below |
| Merge into | Surviving page, for `Merge` rows only |
| Priority | P1 / P2 / P3, see below |
| Status | `To do`, `In progress`, `In PR`, `Done - recheck` (yellow row), `Done` (grey row). Dropdown plus conditional formatting |
| Notes | Why the verdict, then a running log: PR number, merge date, the commit code was verified against, re-check reasons |
| Issue | The page's GitHub "Content cleanup" issue |
| Review | `High` means a full review (below). Blank means lightweight |

**Verdicts**

- **Keep**: page stays. `High`-tier keepers still get an editorial review,
  keyword research, and an image or diagram where it helps.
- **Update**: retitle, rewrite the metadata, or rewrite the body.
- **Merge**: fold the useful material into the `Merge into` page and add
  the old URL to the survivor's `aliases:`.
- **Noindex**: page stays live with `noindex: true` (thin, or ranking past
  page 3 on generic textbook terms).
- **Delete**: only for unpublished drafts with no impressions. An indexed
  URL is never silently deleted (`AGENTS.md` rule 5).
- **Publish**: finish a draft and publish it.
- **Review**: an on-thesis draft. Decide whether to revive it or delete it.

**Priority**

- **P1**: first-impression pages (home, About, Resume, the `/software/` hub)
  and pages already ranking on page 1, where a better title and content can
  turn impressions into clicks.
- **P2**: pillar and proof-project pages, merges, and the noindex cleanup.
- **P3**: engineering-notebook notes and the remaining drafts.

### Tab 2: Page queries

The top 10 Search Console queries per page for `High`-tier pages (90 days
ending 2026-10-29). Columns: Page, Query, Clicks, Impressions, CTR, Avg
position, Source. These were pulled from the signed-in Search Console UI
through Chrome, one page filter at a time. "(no visible queries)" means
Search Console anonymized the impressions or there were none.

Use this tab for keyword research. LLM-estimated search volumes are not
evidence.

### Tab to add: Measurements

The baseline columns hold "before". The "after" needs its own place:
one row per page per check, with columns Date, Page, Window, Impressions,
Clicks, CTR, Avg position, Change vs baseline, and Note. Until this tab
exists, record re-check results in Notes.

## Process

### Phase 0: Positioning (done October 2026)

Audience, thesis, pillars and content tests were set in `POSITIONING.md`
before any triage, because "doesn't fit" only means something against a
defined pillar set. Re-run triage whenever `POSITIONING.md` changes.

### Phase 1: Inventory and triage (done October 2026)

1. Export Search Console performance (Pages, then Queries) for the baseline window.
2. Inventory every `content/**/*.md` with its front matter (title, draft, noindex).
3. Join the two into the tracker, one row per file.
4. Score each page against the content tests and assign a Verdict, Priority and Review tier.
5. Rusty reviews and overrides the verdicts. Closely related pages are
   decided as a cluster (e.g. the IoT architecture pages, the streaming-video notes).

### Phase 2: Execute, one batch at a time

**Batching.** Group cheap mechanical work into one PR: deletes and
noindexes all went out together in #200. Give each `High` page its own PR.

**Per page, `High` tier:**

1. Pick the lowest-numbered priority with Status `To do`. Set it to `In progress`.
2. Re-read the verdict against `POSITIONING.md`. If it no longer holds, change
   it in the tracker before writing anything.
3. Keyword research: use the page's rows in Page queries. If it has none, or
   they are more than about 6 weeks old, pull fresh page-filtered queries
   (90 days) from Search Console. Check the current results page for search intent.
4. Write a brief (seo-guide.md, "Article content brief") for substantial
   rewrites and new pieces.
5. Branch from `master` (`content/<slug>`). Edit the page.
6. Verify every technical claim and code snippet against the source repo at a
   pinned commit, and compile and run the snippets. Record the commit in Notes
   (e.g. `verified against trader@3f8dd53`).
7. Front matter: quoted `title:`, a 140–160 character `description:`, and
   `aliases:` for any merged URL.
8. Run `make check-site`. CI runs the same checks on every PR.
9. Open the PR with `Refs #N`, or `Closes #N` if it finishes the issue's
   checklist. Set Status to `In PR` and put the PR number in Notes.
10. Independent review: a different model, or a fresh agent without the
    drafter's context, checks facts, code and fit, and comments on the PR.
    The drafter never certifies its own technical correctness.
11. Rusty approves and merges. Nothing auto-merges.
12. Set Status to `Done`, or to `Done - recheck` if something outside the
    page can make it stale (e.g. #205, trader-mcp returning after the Trader
    migration). Log the PR, merge date and re-check reason in Notes.

**Lightweight (Review column blank):** metadata or typo fixes go straight
to a single PR with no brief and no independent review. Deletes need no
issue; mention the issue number in the commit if one exists.

**Agent rules:** only one agent writes to a branch at a time. Never push to
`master`, because it auto-deploys. Local Claude Code picks up `AGENTS.md`
automatically. A claude.ai session reads the tracker through the Google
Sheets connector and the repo by cloning it.

### Phase 3: Measure

1. About 4 weeks after a page merges (results take 3–6 weeks to show), pull
   that page's Search Console numbers for a window that starts after the
   merge date.
2. Record them in Measurements and compare them to the baseline columns.
3. Judge results by cluster, not by single page. At this site's traffic,
   a CTR change on one page is mostly noise.
4. If a page is still at position 50 or worse on its target terms after a
   rewrite, revisit its verdict (merge or noindex) instead of rewriting it again.

### Phase 4: Pillars and new content

Once the P1/P2 pages are done: build out the `/software/` hub as the
"Delivering software with AI" pillar, link the proof projects (Trader, OttO,
RedEye) up to the pillars, and write new pieces from the backlog (#197, Trader
ADR articles). The same per-page loop applies, starting from a brief.

## Known constraints

- GitHub Pages cannot issue true 301 redirects. Hugo `aliases:` generate
  meta-refresh pages, which Google usually treats as a redirect.
- Because of that, `/notes/motor-controlor-notes/` keeps its misspelled URL:
  it is the site's top page.
- Tag and category pages are always noindexed (too thin to rank).
- Re-checks pending outside the site: #205 (trader-mcp pages).

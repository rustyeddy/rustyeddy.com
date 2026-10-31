# AGENTS.md

Instructions for any AI coding or writing agent working in this repo
(Claude, Codex, GPT, Gemini, and others).

1. Read `POSITIONING.md` before writing, editing, retitling, or
   pruning content. It defines the audience and the content tests.
2. Follow `EDITORIAL.md` for voice, quality checklist, and
   dispositions, and `STYLEGUIDE.md` for formatting.
3. Repo mechanics (build, layout, drafts, front matter) are in
   `CLAUDE.md`; they apply to every agent, not only Claude.
4. Never push to `master`: it auto-deploys. Work on a branch and open
   a pull request for review.
5. When merging or removing a page that has search impressions, add
   the old URL to the surviving page's `aliases:` so Hugo emits a
   redirect. Never silently delete an indexed URL.
6. Always double-quote `title:` and `summary:` values in front matter
   (e.g. `title: "Money in Go: Fixed-Point Types"`). An unquoted
   colon is invalid YAML and breaks the Hugo build, even in a draft.
   `scripts/check-metadata` (run by `make check-site`) catches this.

# CLAUDE.md

Working notes for Claude (and humans) on rustyeddy.com.

## What this is

Hugo static site. GitHub Actions builds and deploys to GitHub Pages
on every push to `master`. The `rustyeddy.com` CNAME is in
`static/CNAME` (Hugo copies it to the build output automatically).
Bootstrap 5 (via CDN) plus custom SCSS in `assets/scss/`. Diagrams
are Graphviz `.dot` files in `diagrams/` compiled to SVGs under
`static/diagrams/` by the Makefile.

## Build & dev

- `make serve` — `hugo serve` on `0.0.0.0:1313`, no cache, watch
- `make drafts` — same but also renders pages with `draft: true`
- `make` — local build into `docs/` (gitignored). Use to preview a
  production build; don't commit `docs/`.
- `make check-site` — full site audit (`hugo --minify`, links,
  metadata, discovery, visible marker scan, optional markdown lint)

Deployment is fully automated: push source to `master` → Actions
runs `.github/workflows/hugo.yml` → Pages deploys. You never need
to build or commit `docs/` manually.

## Audience and voice

The site is written for **engineering peers and hiring managers**.
It's both a portfolio (credibility for technical readers and people
evaluating Rusty) and a long-form technical writing destination.

Voice and structure rules live in `knowledge/styleguide.md`. The
short version: architecture-first, decision-oriented, tradeoffs over
prescriptions, no marketing language. Code is optional and only
included when it clarifies a concept.

## Content layout

```
content/
  _index.md         Home hero copy. Keep short — it renders into the
                    homepage via layouts/index.html.
  about/            Bio.
  iot/              IoT pillar essays.
  software/         Software-engineering pillar essays.
  notes/            Short technical notes / field notes.
  projects/         Project showcase pages.
  resume/           Resume detail (jobs, clients, edu, skills, pubs).
```

### Where new content goes

- Pillar architecture/design essay → `iot/` or `software/`
- Short snippet, lab note, hardware observation → `notes/`
- Project showcase → `projects/<slug>/_index.md`
- Don't create new top-level sections without discussion (we just
  removed `sailing/`, `thoughts/`, and `notes/drafts/`)

### Drafts workflow

Use `draft: true` in the front matter. **Do not** create a
sub-folder named `drafts/` — we explicitly dissolved that pattern
because it generated confusing URLs and accumulated abandoned work.
Use `make drafts` to preview unpublished pages.

### Front matter

Template lives in `knowledge/front-matter-templ.md`. Minimum every
article needs: `title`, `date`, `description`. Tags/categories are
currently inconsistent across the site; a unified taxonomy pass is on
the roadmap but not yet done.

## Templates

- `layouts/_default/baseof.html` — shell used by most pages
- `layouts/_default/{list,section,single}.html` — defaults
- `layouts/index.html` — homepage; extends baseof; renders hero from
  `content/_index.md`, three cards, and the six most-recent articles
  pulled from `iot`/`software`/`notes`
- `layouts/partials/blog-header.html` — the title + description
  jumbotron used across all pages
- Section-specific layouts under `layouts/{iot,software,projects,
  resume,job}/`

GA4 is wired in `layouts/partials/head-cheese.html`. There used to
be a duplicate legacy UA tag in the footer — it's gone, don't put
analytics back in the footer.

## Roadmap

`knowledge/roadmap.md` tracks what exists, what was originally
planned, and what still needs to be written or fixed. It replaces an
older `sitemap.yml` that described a fictional structure. Update the
roadmap when you finish a planned item or add a new pillar to write.

The current flagship-project page to build is `/projects/otto/`,
sourced from `iot/iot-system-architecture-otto.md`,
`iot/self-watering-garden.md`, and
`iot/building-iot-device-manager-in-go.md`.

## Pitfalls to avoid

- Don't link to pillar pages that don't exist. The previous
  `iot/_index.md` listed four broken pillars (`iot-device-management`,
  `edge-device-architecture`, `system-design-principles`,
  `sdlc-for-small-teams`). They were removed; track wanted articles
  in `knowledge/roadmap.md` instead.
- Don't add jQuery — Bootstrap 5's bundled JS includes Popper and is
  enough.
- `data/references.yml` is a curated link list but is **not currently
  rendered** by any layout. If you want it on the site, write a
  partial that reads `site.Data.references` and include it where
  appropriate.
- `content/_index.md` is small on purpose. The numbered topic list
  that used to live there was removed because the homepage cards
  cover the same paths.

## What was recently pruned (2026-05)

About 1,700 lines of stale content were deleted:

- 24 abandoned 2017–2020 drafts under `notes/drafts/`
- 2 near-empty published software pages
- 2 stalled 2025 IoT drafts
- The `sailing/` and `thoughts/` sections
- 3 unfinished project pages (`oclv`, `recam`, `vue`)

If you're tempted to recreate any of these, check `git log` first —
they were intentionally removed.

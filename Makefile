DOTS := $(wildcard diagrams/*.dot)
SVGS := $(patsubst diagrams/%.dot,static/diagrams/%.svg,$(DOTS))

all: build $(SVGS)

build: check-metadata
	hugo --gc --cleanDestinationDir

drafts: assets/scss/style.scss
	hugo serve --buildDrafts --ignoreCache --noHTTPCache --bind "0.0.0.0" --watch 

serve:
	hugo serve --ignoreCache --noHTTPCache --watch --bind "0.0.0.0" --baseURL http://localhost:1313

prod: assets/scss/style.scss
	hugo serve --ignoreCache --noHTTPCache --renderToDisk --watch

scss static/css/style.css: assets/scss/style.scss
	scss assets/scss/style.scss:static/css/style.css

check: check-metadata build check-links check-discovery

check-site:
	./scripts/check-site

check-links:
	scripts/check-links

check-discovery:
	scripts/check-discovery

check-metadata:
	scripts/check-metadata

static/diagrams/%.svg: diagrams/%.dot
	dot -Tsvg $< -o $@

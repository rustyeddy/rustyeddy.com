DOTS := $(wildcard diagrams/*.dot)
SVGS := $(patsubst diagrams/%.dot,static/diagrams/%.svg,$(DOTS))

all: build $(SVGS)

build:
	hugo

drafts: assets/scss/style.scss
	hugo serve --buildDrafts --ignoreCache --noHTTPCache --bind "0.0.0.0" --watch 

serve:
	hugo serve --ignoreCache --noHTTPCache --watch --bind "0.0.0.0" --baseURL http://localhost:1313

prod: assets/scss/style.scss
	hugo serve --ignoreCache --noHTTPCache --renderToDisk --watch

scss static/css/style.css: assets/scss/style.scss
	scss assets/scss/style.scss:static/css/style.css

static/diagrams/%.svg: diagrams/%.dot
	dot -Tsvg $< -o $@

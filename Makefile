all:
build:
	hugo

drafts: assets/scss/style.scss
	hugo serve --buildDrafts --ignoreCache --noHTTPCache --watch 

serve:
	hugo serve --ignoreCache --noHTTPCache --watch 

prod: assets/scss/style.scss
	hugo serve --ignoreCache --noHTTPCache --renderToDisk --watch

scss static/css/style.css: assets/scss/style.scss
	scss assets/scss/style.scss:static/css/style.css


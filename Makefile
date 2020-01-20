build:
	hugo

drafts:
	hugo serve --buildDrafts --ignoreCache --noHTTPCache --watch 

serve:
	hugo serve --ignoreCache --noHTTPCache --watch 

prod:
	hugo serve --ignoreCache --noHTTPCache --renderToDisk --watch

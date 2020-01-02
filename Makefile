build:
	hugo

serve:
	hugo serve --buildDrafts --ignoreCache --noHTTPCache --watch 

prod:
	hugo serve --ignoreCache --noHTTPCache --renderToDisk --watch

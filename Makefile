build:
	hugo

serve:
	hugo serve --buildDrafts --ignoreCache --noHTTPCache --renderToDisk --watch 

prod:
	hugo serve --ignoreCache --noHTTPCache --renderToDisk --watch

.PHONY: check
check:
	docker build --tag freckle/platform-action .
	docker run -it --rm freckle/platform-action \
	  -t $(GITHUB_TOKEN) \
	  -c 'RIO_VERBOSE=1 platform deploy -e dev foo/bar'

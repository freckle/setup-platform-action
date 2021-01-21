.PHONY: check
check:
	docker build --tag freckle/platform-action .
	docker run -it --rm --env-file "$(PWD)"/.env freckle/platform-action \
	  sh -c 'RIO_VERBOSE=1 platform deploy -e dev --tag latest'

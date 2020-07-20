.PHONY: example-builders
example-builders:
	cd labs && ./example-builders.sh

.PHONY: example-provisioners
example-provisioners:
	cd labs \
	&& ./example-provisioners.sh &> ./example-provisioners.console

.PHONY: wordpress-nginx
wordpress-nginx:
	cd labs \
	&& ./wordpress-nginx.sh &> ./wordpress-nginx.console

.PHONY: cleanup
cleanup:
	cd labs \
	&& ./cleanup.sh &> ./cleanup.console

.PHONY: all
all: example-builders example-provisioners wordpress-nginx cleanup

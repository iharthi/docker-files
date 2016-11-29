NAME = thorgate/drone-celery-alpine-3.5
VERSION = 1.3.0

# Configure make
.PHONY: help common build tag_latest push release
.DEFAULT_GOAL := help
.SHELL = '/bin/bash'

# Colors
C_BG = \033[32;01m
C_BY = \033[33;01m
C_OFF = \033[0m

# Goals
help:
	@echo "Goals"
	@echo "===================================================================================================="
	@echo "$(C_BG)make release$(C_OFF)            Run build->tag_latest->push"
	@echo "$(C_BG)make build$(C_OFF)              Build $(NAME):$(VERSION)"
	@echo "$(C_BG)make tag_latest$(C_OFF)         Tag $(NAME):$(VERSION) as :latest"
	@echo "$(C_BG)make push$(C_OFF)               Push $(NAME):$(VERSION) to docker registry"

build: common
ifdef REBUILD
	@echo "REBUILDING $(NAME):$(VERSION)"
	docker build -t $(NAME):$(VERSION) .
else
	@if docker images $(NAME) | awk '{ print $2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is already built. Use 'REBUILD=1 make build' to rebuild"; false; fi
	docker build -t $(NAME):$(VERSION) .
endif

tag_latest:
	@echo "$(C_BY)Tag $(NAME):$(VERSION) as :latest?$(C_OFF)"
	@read -p "[y/N] " TAG_LATEST; \
	if [ $$TAG_LATEST != "y" ] && [ $$TAG_LATEST != "Y" ]; then \
		echo 'not tagging'; \
	else \
		docker tag $(NAME):$(VERSION) $(NAME):latest; \
	fi

push:
	@if ! docker images $(NAME) | awk '{ print $2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)

release:
	@if ! docker images $(NAME) | awk '{ print $2 }' | grep -q -F $(VERSION); then $(MAKE) build; fi
	$(MAKE) tag_latest
	$(MAKE) push

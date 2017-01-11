NAME = thorgate/python3.5-pretenders
VERSION = 1.4.3

# Configure make
.PHONY: help build tag_latest push release prep_repo
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

prep_repo: archived-$(VERSION).zip code-$(VERSION)
	yes | cp Dockerfile code-$(VERSION)/pretenders-$(VERSION)/Dockerfile
	yes | cp docker-entrypoint code-$(VERSION)/pretenders-$(VERSION)/docker-entrypoint

archived-$(VERSION).zip:
	wget -O archived-$(VERSION).zip https://github.com/pretenders/pretenders/archive/$(VERSION).zip

code-$(VERSION):
	unzip -d code-$(VERSION) archived-$(VERSION).zip

build: prep_repo
ifdef REBUILD
	@echo "REBUILDING $(NAME):$(VERSION)"
	docker build -t $(NAME):$(VERSION) code-$(VERSION)/pretenders-$(VERSION)/
else
	@if docker images $(NAME) | awk '{ print $2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is already built. Use 'REBUILD=1 make build' to rebuild"; false; fi
	docker build -t $(NAME):$(VERSION) code-$(VERSION)/pretenders-$(VERSION)/
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

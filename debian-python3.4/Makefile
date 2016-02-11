.PHONY: release tag_latest build

NAME = thorgate/debian-python3.4
VERSION = 1.0.0

common:
	cp -R ../common .

build: common
	docker build -t $(NAME):$(VERSION) --rm .

build-fast: common
	docker build -t $(NAME):$(VERSION) .

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

push:
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)

release: tag_latest build push
release-fast: build-fast tag_latest push

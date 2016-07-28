.PHONY: release tag_latest build common

NAME = thorgate/postgres-9.4-et-ru
VERSION = 1.0.0

common:
	yes | cp -rf ../common ./.common

build: common
	docker build -t $(NAME):$(VERSION) --rm .

build-fast: common
	docker build -t $(NAME):$(VERSION) .

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

push:
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)

release: build tag_latest push
release-fast: build-fast tag_latest push


include ./hack/help.mk

UID:=$(shell id -u)
GID:=$(shell id -g)
PWD:=$(shell pwd)

.PHONY: clear-cache
clear-cache: ##@dev clear elm cache
	rm -rf /tmp/.elm
	rm -rf $(PWD)/elm-stuff

.PHONY: cli
cli: ##@dev provide docker based environment with elm tooling
	docker run -it --rm -v "$(PWD):/code" -w "/code" -v "/tmp/.elm:/tmp/.elm" -e "HOME=/tmp" -u "$(UID):$(GID)" -p 8031:8031 --entrypoint="bash" codesimple/elm:0.19

.PHONY: build
build: ##@build builds js file from elm source files
	docker run -it --rm -v "$(PWD):/code" -w "/code" -v "/tmp/.elm:/tmp/.elm" -e "HOME=/tmp" -u "$(UID):$(GID)" --entrypoint="bash" codesimple/elm:0.19 -c "elm make src/Main.elm --output=dist/build.js --optimize"

.PHONY: serve
serve: ##@dev runs node server which serves elm apps on port :8000
	docker run -it --rm -v "$(PWD):/code" -w "/code" -v "/tmp/.elm:/tmp/.elm" -e "HOME=/tmp" -u "$(UID):$(GID)" -p 8033:8033 codesimple/elm:0.19 reactor --port 8033

.PHONY: serve-api-mock
serve-api-mock: ##@dev start api mock server
	docker build -t json-server docker/json-server
	docker run -it --rm -v "$(PWD)/data:/data" -w /data -u "$(UID):$(GID)" -p 9988:9988 json-server --watch db.json -p 9988 --host 0.0.0.0

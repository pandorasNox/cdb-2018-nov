
include ./hack/help.mk

UID:=$(shell id -u)
GID:=$(shell id -g)
PWD:=$(shell pwd)

DOCKER_NODE_ELM_REACT_IMG_SHA:=$(shell docker build -q ./docker/node-elm-react)

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

.PHONY: init-react
init-react: ##@dev
	docker run -it --rm -v "$(PWD)/src/react:/temp" create-react-app /temp
	sudo chown -R "$(UID):$(GID)" "$(PWD)/src/react"

.PHONY: serve-react
serve-react: ##@dev
	docker run -it --rm -v "$(PWD)/src/react:/temp" -w "/temp" -p 9966:3000 node:10.13.0-alpine npm start

.PHONY: eject-react
eject-react: ##@dev
	docker run -it --rm -v "$(PWD)/src/react:/temp" -w "/temp" -p 9966:3000 node:10.13.0-alpine npm run eject
	sudo chown -R "$(UID):$(GID)" "$(PWD)/src/react"

.PHONY: node-cli
node-cli: ##@dev
	docker run -it --rm -v "$(PWD)/src/react:/temp" -w "/temp" -p 9966:3000 $(DOCKER_NODE_ELM_REACT_IMG_SHA) sh

.PHONY: fix
fix: ##@setup e.g. fix directory rights
	sudo chown -R "$(UID):$(GID)" "$(PWD)/src/react"
	mkdir -p /tmp/.elm/0.19.0

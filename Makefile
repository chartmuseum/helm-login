PLUGIN_NAME := login

HAS_DEP := $(shell command -v dep;)
HAS_PIP := $(shell command -v pip;)
HAS_VENV := $(shell command -v virtualenv;)

.PHONY: bootstrap
bootstrap:
ifndef HAS_DEP
	@go get -u github.com/golang/dep/cmd/dep
endif
	@dep ensure -v -vendor-only

.PHONY: build
build: build_linux build_mac build_windows

build_windows: export GOARCH=amd64
build_windows:
	@GOOS=windows go build -v --ldflags="-w -X main.Version=$(VERSION) -X main.Revision=$(REVISION)" \
		-o bin/windows/amd64/helmlogin cmd/helmlogin/main.go  # windows

link_windows:
	@cp bin/windows/amd64/helmlogin ./bin/helmlogin

build_linux: export GOARCH=amd64
build_linux: export CGO_ENABLED=0
build_linux:
	@GOOS=linux go build -v --ldflags="-w -X main.Version=$(VERSION) -X main.Revision=$(REVISION)" \
		-o bin/linux/amd64/helmlogin cmd/helmlogin/main.go  # linux

link_linux:
	@cp bin/linux/amd64/helmlogin ./bin/helmlogin

build_mac: export GOARCH=amd64
build_mac: export CGO_ENABLED=0
build_mac:
	@GOOS=darwin go build -v --ldflags="-w -X main.Version=$(VERSION) -X main.Revision=$(REVISION)" \
		-o bin/darwin/amd64/helmlogin cmd/helmlogin/main.go # mac osx
	@cp bin/darwin/amd64/helmlogin ./bin/helmlogin # For use w make install

link_mac:
	@cp bin/darwin/amd64/helmlogin ./bin/helmlogin

.PHONY: clean
clean:
	@git status --ignored --short | grep '^!! ' | sed 's/!! //' | xargs rm -rf

.PHONY: test
test: setup-test-environment
	@./scripts/test.sh

.PHONY: covhtml
covhtml:
	@go tool cover -html=.cover/cover.out

.PHONY: tree
tree:
	@tree -I vendor

.PHONY: release
release:
	@scripts/release.sh $(VERSION)

.PHONY: install
install:
	HELM_LOGIN_PLUGIN_NO_INSTALL_HOOK=1 helm plugin install $(shell pwd)

.PHONY: remove
remove:
	helm plugin remove $(PLUGIN_NAME)

.PHONY: setup-test-environment
setup-test-environment:
ifndef HAS_PIP
	@apt-get update && apt-get install -y python-pip
endif
ifndef HAS_VENV
	@pip install virtualenv
endif
	@./scripts/setup_test_environment.sh

.PHONY: acceptance
acceptance: setup-test-environment
	@./scripts/acceptance.sh

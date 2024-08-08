# Nebulant bridge Makefile.
# github.com/develatio/nebulant-bridge

VERSION = 0
PATCHLEVEL = 5
SUBLEVEL = 1
EXTRAVERSION = -beta
# EXTRAVERSION := -beta-git-$(shell git log -1 --format=%h)
NAME =

######

BRIDGEVERSION = $(VERSION)$(if $(PATCHLEVEL),.$(PATCHLEVEL)$(if $(SUBLEVEL),.$(SUBLEVEL)))$(EXTRAVERSION)
DATE = $(shell git log -1 --date=format:'%Y%m%d' --format=%cd)
COMMIT = $(shell git log -1 --format=%h)
GOVERSION = $(shell go env GOVERSION)

PRERELEASE = true
ifeq ($(shell expr $(PATCHLEVEL) % 2), 0)
	PRERELEASE = false
endif

PKG_LIST := $(shell go list ./... | grep -v /vendor/)


LDFLAGS = -X github.com/develatio/nebulant-bridge/bconfig.Version=$(BRIDGEVERSION)\
	-X github.com/develatio/nebulant-bridge/bconfig.VersionDate=$(DATE)\
	-X github.com/develatio/nebulant-bridge/bconfig.VersionCommit=$(COMMIT)\
	-X 'github.com/develatio/nebulant-bridge/bconfig.VersionGo=$(GOVERSION)'


MINGOVERSION = 1.21.0

ifndef $(GOPATH)
    GOPATH=$(shell go env GOPATH)
    export GOPATH
endif

ifndef $(GOOS)
    GOOS=$(shell go env GOOS)
    export GOOS
endif

ifndef $(GOARCH)
    GOARCH=$(shell go env GOARCH)
    export GOARCH
endif

GOEXE=$(shell go env GOEXE)

.PHONY: create-network
create-network:
	docker network create nebulant-lan 2> /dev/null || true

.PHONY: runrace
runrace:
	CGO_ENABLED=1 go run -race -ldflags "$(LDFLAGS)" bridge.go $(ARGS)

.PHONY: run
run:
	CGO_ENABLED=1 go run -ldflags "$(LDFLAGS)" bridge.go $(ARGS)

.PHONY: rundocker
rundocker: create-network
	docker compose -f docker-compose.yml up bridge

build:
	GO111MODULE=on CGO_ENABLED=0 GOOS=$(GOOS) GOARCH=$(GOARCH) go build -a -trimpath -ldflags "-w -s $(LDFLAGS)" -o dist/nebulant-bridge$(GOEXE) bridge.go

.PHONY: build_platform
build_platform:
	@mkdir -p dist/v$(BRIDGEVERSION)
	GO111MODULE=on CGO_ENABLED=0 GOOS=$(GOOS) GOARCH=$(GOARCH) go build -a -trimpath -ldflags "-w -s $(LDFLAGS) $(EXTRAFLAGS)" -o dist/v$(BRIDGEVERSION)/nebulant-bridge$(DIST_SUFFIX) bridge.go
	@shasum -a 256 dist/v$(BRIDGEVERSION)/nebulant-bridge$(DIST_SUFFIX) > dist/v$(BRIDGEVERSION)/nebulant-bridge$(DIST_SUFFIX).checksum
	@printf "sha256: "
	@cat dist/v$(BRIDGEVERSION)/nebulant-bridge$(DIST_SUFFIX).checksum

.PHONY: buildall
buildall:
	GOOS=linux GOARCH=arm GOEXE= DIST_SUFFIX=-linux-arm $(MAKE) build_platform
	GOOS=linux GOARCH=arm64 GOEXE= DIST_SUFFIX=-linux-arm64 $(MAKE) build_platform
	GOOS=linux GOARCH=386 GOEXE= DIST_SUFFIX=-linux-386 $(MAKE) build_platform
	GOOS=linux GOARCH=amd64 GOEXE= DIST_SUFFIX=-linux-amd64 $(MAKE) build_platform
	GOOS=freebsd GOARCH=arm GOEXE= DIST_SUFFIX=-freebsd-arm $(MAKE) build_platform
	GOOS=freebsd GOARCH=arm64 GOEXE= DIST_SUFFIX=-freebsd-arm64 $(MAKE) build_platform
	GOOS=freebsd GOARCH=386 GOEXE= DIST_SUFFIX=-freebsd-386 $(MAKE) build_platform
	GOOS=freebsd GOARCH=amd64 GOEXE= DIST_SUFFIX=-freebsd-amd64 $(MAKE) build_platform
	GOOS=openbsd GOARCH=arm GOEXE= DIST_SUFFIX=-openbsd-arm $(MAKE) build_platform
	GOOS=openbsd GOARCH=arm64 GOEXE= DIST_SUFFIX=-openbsd-arm64 $(MAKE) build_platform
	GOOS=openbsd GOARCH=386 GOEXE= DIST_SUFFIX=-openbsd-386 $(MAKE) build_platform
	GOOS=openbsd GOARCH=amd64 GOEXE= DIST_SUFFIX=-openbsd-amd64 $(MAKE) build_platform
	GOOS=windows GOARCH=arm GOEXE=.exe DIST_SUFFIX=-windows-arm.exe $(MAKE) build_platform
	GOOS=windows GOARCH=arm64 GOEXE=.exe DIST_SUFFIX=-windows-arm64.exe $(MAKE) build_platform
	GOOS=windows GOARCH=386 GOEXE=.exe DIST_SUFFIX=-windows-386.exe $(MAKE) build_platform
	GOOS=windows GOARCH=amd64 GOEXE=.exe DIST_SUFFIX=-windows-amd64.exe $(MAKE) build_platform
	GOOS=darwin GOARCH=arm64 GOEXE= DIST_SUFFIX=-darwin-arm64 $(MAKE) build_platform
	GOOS=darwin GOARCH=amd64 GOEXE= DIST_SUFFIX=-darwin-amd64 $(MAKE) build_platform
	# GOOS=js GOARCH=wasm GOEXE= DIST_SUFFIX=-js-wasm $(MAKE) build_platform


.PHONY: secure
secure:
	# https://github.com/securego/gosec/blob/master/README.md
	# G307 -- https://github.com/securego/gosec/issues/512
	$(GOPATH)/bin/gosec -exclude=G307 ./...

.PHONY: staticanalysis
staticanalysis:
	# https://github.com/praetorian-inc/gokart
	$(GOPATH)/bin/gokart scan -v

.PHONY: unittest
unittest:
	go test -v -race $(PKG_LIST)

.PHONY: cover
cover:
	go test -cover -v -race $(PKG_LIST)

.PHONY: htmlcover
htmlcover:
	go test -coverprofile cover.out -v -race $(PKG_LIST)
	go tool cover -html=cover.out

.PHONY: bridgeversion
bridgeversion:
	@echo $(BRIDGEVERSION)

.PHONY: ispre
ispre:
	@echo $(PRERELEASE)

.PHONY: versiondate
versiondate:
	@echo $(DATE)

.PHONY: goversion
goversion:
	@echo $(MINGOVERSION)

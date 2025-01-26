NIX ?= nix --extra-experimental-features nix-command --extra-experimental-features flakes

self := $(shell whoami)@$(shell hostname)
flake := $(shell $(NIX) flake metadata --json | jq -r .path)
darwinConfigurations := $(notdir $(wildcard ./config/darwin/*))
homeConfigurations := $(notdir $(wildcard ./config/home/*))

ifeq ($(shell uname),Darwin)
.DEFAULT_GOAL := $(shell hostname)
else
.DEFAULT_GOAL := $(self)
endif

$(darwinConfigurations):
	+darwin-rebuild \
	--flake $(flake)#$@ \
	--print-build-logs \
	--show-trace \
	switch

$(filter-out $(self),$(homeConfigurations)):
	+$(NIX) copy $(flake) \
	--to ssh-ng://$@?remote-program=/nix/var/nix/profiles/default/bin/nix-daemon
	+ssh -t $@ PATH=/nix/var/nix/profiles/default/bin $(NIX) run home-manager -- \
	--flake $(flake)#$@ \
	--no-write-lock-file \
	--print-build-logs \
	--show-trace \
	switch

ifneq (,$(findstring $(self),$(homeConfigurations)))
$(self):
	+$(NIX) run home-manager -- \
	--flake $(flake)#$@ \
	--no-write-lock-file \
	--print-build-logs \
	--show-trace \
	switch
endif

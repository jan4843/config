NIX ?= nix --extra-experimental-features nix-command --extra-experimental-features flakes

host := $(shell hostname)
home := $(shell whoami)@$(hostname)
flake := $(shell $(NIX) flake metadata --json | jq -r .path)

darwinConfigurations := $(notdir $(wildcard ./config/darwin/*))
nixosConfigurations := $(notdir $(wildcard ./config/nixos/*))
homeConfigurations := $(notdir $(wildcard ./config/home/*))

ifeq ($(shell uname),Darwin)
.DEFAULT_GOAL := $(host)
else ifneq (,$(wildcard /etc/NIXOS))
.DEFAULT_GOAL := $(host)
else
.DEFAULT_GOAL := $(home)
endif

# darwin remote
$(filter-out $(host),$(darwinConfigurations)):
	$(error Remote Darwin not supported)

# darwin local
ifneq (,$(findstring $(host),$(darwinConfigurations)))
$(host):
	+darwin-rebuild \
	--flake $(flake)#$@ \
	--no-write-lock-file \
	--print-build-logs \
	--show-trace \
	switch
endif

# nixos remote
$(filter-out $(host),$(nixosConfigurations)):
	+$(NIX) copy $(flake) \
	--to ssh-ng://$@
	+ssh -t $@ nixos-rebuild \
	--flake $(flake)#$@ \
	--no-write-lock-file \
	--print-build-logs \
	--show-trace \
	switch

# nixos local
ifneq (,$(findstring $(host),$(nixosConfigurations)))
$(host):
	$(error Local NixOS not supported)
endif

# home remote
$(filter-out $(home),$(homeConfigurations)):
	+$(NIX) copy $(flake) \
	--to ssh-ng://$@?remote-program=/nix/var/nix/profiles/default/bin/nix-daemon
	+ssh -t $@ PATH=/nix/var/nix/profiles/default/bin $(NIX) run home-manager -- \
	--flake $(flake)#$@ \
	--no-write-lock-file \
	--print-build-logs \
	--show-trace \
	switch

# home local
ifneq (,$(findstring $(home),$(homeConfigurations)))
$(home):
	+$(NIX) run home-manager -- \
	--flake $(flake)#$@ \
	--no-write-lock-file \
	--print-build-logs \
	--show-trace \
	switch
endif

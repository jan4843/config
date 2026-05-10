SSH_DEST ?= $@
OPTIONS  ?= --print-build-logs
COMMAND  ?= switch

NIX = nix --extra-experimental-features nix-command --extra-experimental-features flakes --accept-flake-config
NIXOS_REBUILD  = $(NIX) run $(FLAKE)\#nixos-rebuild -- --accept-flake-config
DARWIN_REBUILD = $(NIX) run $(FLAKE)\#darwin-rebuild -- --option accept-flake-config true
HOME_MANAGER   = $(NIX) run $(FLAKE)\#home-manager -- --option accept-flake-config true
JQ  = $(NIX) run .\#jq --
GIT = $(NIX) run .\#git --

FLAKE := $(shell $(GIT) add --intent-to-add . && $(NIX) flake lock && $(NIX) flake metadata --json | $(JQ) -r .path)
DARWIN_CONFIGS := $(notdir $(wildcard ./hosts/darwin/*))
NIXOS_CONFIGS  := $(notdir $(wildcard ./hosts/nixos/*))
HOME_CONFIGS   := $(notdir $(wildcard ./hosts/home/*))
ARGS ?= --flake $(FLAKE)\#$@ $(OPTIONS) $(COMMAND)

.DEFAULT_GOAL := $(shell hostname)

# nixos local
ifneq (,$(findstring $(.DEFAULT_GOAL),$(NIXOS_CONFIGS)))
$(.DEFAULT_GOAL):
	$(NIXOS_REBUILD) $(ARGS)
endif

# nixos remote
$(filter-out $(.DEFAULT_GOAL),$(NIXOS_CONFIGS)):
	$(NIX) copy $(FLAKE) --to ssh-ng://$(SSH_DEST)
	ssh -t $(SSH_DEST) $(NIXOS_REBUILD) $(ARGS)

# darwin local
ifneq (,$(findstring $(.DEFAULT_GOAL),$(DARWIN_CONFIGS)))
$(.DEFAULT_GOAL):
	sudo -H $(DARWIN_REBUILD) $(ARGS)
endif

# darwin remote
$(filter-out $(.DEFAULT_GOAL),$(DARWIN_CONFIGS)):
	$(error Remote Darwin not supported)

# home local
ifneq (,$(findstring $(.DEFAULT_GOAL),$(HOME_CONFIGS)))
$(.DEFAULT_GOAL):
	$(HOME_MANAGER) $(ARGS)
endif

# home remote
$(filter-out $(.DEFAULT_GOAL),$(HOME_CONFIGS)):
	$(NIX) copy $(FLAKE) --to ssh-ng://$(SSH_DEST)?remote-program=/nix/var/nix/profiles/default/bin/nix-daemon
	ssh -t $(SSH_DEST) PATH=/nix/var/nix/profiles/default/bin $(HOME_MANAGER) $(ARGS)

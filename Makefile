NIX_OPTIONS ?= --extra-experimental-features nix-command --extra-experimental-features flakes
NIX ?= nix --accept-flake-config $(NIX_OPTIONS)
DARWIN_REBUILD ?= $(NIX) shell $(FLAKE)\#darwin-rebuild --command sudo darwin-rebuild
NIXOS_REBUILD  ?= $(NIX) run $(FLAKE)\#nixos-rebuild --
HOME_MANAGER   ?= $(NIX) run $(FLAKE)\#home-manager -- $(NIX_OPTIONS)
OPTIONS ?= --print-build-logs --show-trace
COMMAND ?= switch
SSH_DESTINATION ?= $@

FLAKE := $(shell { git add --intent-to-add .; $(NIX) flake lock; } 2>/dev/null; $(NIX) flake metadata --json | jq -r .path)
DARWIN_CONFIGS := $(notdir $(wildcard ./hosts/darwin/*))
NIXOS_CONFIGS  := $(notdir $(wildcard ./hosts/nixos/*))
HOME_CONFIGS   := $(notdir $(wildcard ./hosts/home/*))

.DEFAULT_GOAL := $(shell hostname)

# apps
$(notdir $(wildcard ./apps/*)):
	$(NIX) run .#$@

# darwin remote
$(filter-out $(.DEFAULT_GOAL),$(DARWIN_CONFIGS)):
	$(error Remote Darwin not supported)

# darwin local
ifneq (,$(findstring $(.DEFAULT_GOAL),$(DARWIN_CONFIGS)))
$(.DEFAULT_GOAL):
	$(DARWIN_REBUILD) --flake $(FLAKE)#$@ $(OPTIONS) $(COMMAND)
endif

# nixos remote
$(filter-out $(.DEFAULT_GOAL),$(NIXOS_CONFIGS)):
	$(NIX) copy $(FLAKE) --to ssh-ng://$(SSH_DESTINATION)
	ssh -t $(SSH_DESTINATION) $(NIXOS_REBUILD) --flake $(FLAKE)#$@ $(OPTIONS) $(COMMAND)

# nixos local
ifneq (,$(findstring $(.DEFAULT_GOAL),$(NIXOS_CONFIGS)))
$(.DEFAULT_GOAL):
	$(NIXOS_REBUILD) --flake $(FLAKE)#$@ $(OPTIONS) $(COMMAND)
endif

# home remote
$(filter-out $(.DEFAULT_GOAL),$(HOME_CONFIGS)):
	$(NIX) copy $(FLAKE) --to ssh-ng://$(SSH_DESTINATION)?remote-program=/nix/var/nix/profiles/default/bin/nix-daemon
	ssh -t $(SSH_DESTINATION) PATH=/nix/var/nix/profiles/default/bin $(HOME_MANAGER) --flake $(FLAKE)#$@ $(OPTIONS) $(COMMAND)

# home local
ifneq (,$(findstring $(.DEFAULT_GOAL),$(HOME_CONFIGS)))
$(.DEFAULT_GOAL):
	$(HOME_MANAGER) --flake $(FLAKE)#$@ $(OPTIONS) $(COMMAND)
endif

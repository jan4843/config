{
  # common
  inputs = {
    # https://nixos.org/manual/nixos/stable/release-notes
    # https://nixos.org/manual/nixpkgs/stable/release-notes
    nixpkgs_linux = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
    };
    nixpkgs_darwin = {
      url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    };

    nixpkgs-25-05_linux.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # https://nix-community.github.io/home-manager/release-notes.xhtml
    home-manager_linux = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };
    home-manager_darwin = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };

    nix-vscode-extensions_linux = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };
    nix-vscode-extensions_darwin = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };
  };

  # linux
  inputs = {
    nixos-hardware_linux = {
      url = "github:nixos/nixos-hardware";
    };

    lsfg-vk_linux = {
      url = "github:pabloaul/lsfg-vk-flake/1.0.0?latest=true";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };
  };

  # darwin
  inputs = {
    nix-darwin_darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };

    homebrew = {
      url = "github:homebrew/brew/5.0.4?latest=true";
      flake = false;
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs: import ./outputs.nix inputs;
}

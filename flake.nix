{
  outputs = inputs: import ./outputs.nix inputs;
  inputs = {
    # common

    nixpkgs = {
      url = "file:///dev/null";
      flake = false;
    };
    nixpkgs_darwin = {
      url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    };
    nixpkgs_linux = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };

    home-manager_darwin = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };
    home-manager_linux = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };

    nix-vscode-extensions_darwin = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };
    nix-vscode-extensions_linux = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };

    # darwin

    nix-darwin_darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };

    homebrew_darwin = {
      url = "github:homebrew/brew/4.4.20";
      flake = false;
    };
    homebrew-bundle_darwin = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core_darwin = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask_darwin = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    # linux

    nixos-hardware_linux = {
      url = "github:NixOS/nixos-hardware";
    };
  };
}

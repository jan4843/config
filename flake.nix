{
  inputs = {
    # nixpkgs
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

    # nix-darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };

    # home-manager
    home-manager_darwin = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };
    home-manager_linux = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };

    # nix-vscode-extensions
    nix-vscode-extensions_darwin = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };
    nix-vscode-extensions_linux = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };

    # homebrew
    homebrew = {
      url = "github:homebrew/brew/4.4.17";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
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

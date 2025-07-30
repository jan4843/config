{
  outputs = inputs: import ./outputs.nix inputs;

  # common
  inputs = {
    # https://nixos.org/manual/nixos/stable/release-notes
    # https://nixos.org/manual/nixpkgs/stable/release-notes
    nixpkgs_darwin = {
      url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    };
    nixpkgs_linux = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };

    # https://nix-community.github.io/home-manager/release-notes.xhtml
    home-manager_darwin = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };
    home-manager_linux = {
      url = "github:nix-community/home-manager/release-25.05";
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
  };

  # darwin
  inputs = {
    nix-darwin_darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };

    homebrew_darwin = {
      url = "github:homebrew/brew/4.5.13";
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
  };

  # linux
  inputs = {
    nixos-hardware_linux = {
      url = "github:NixOS/nixos-hardware";
    };

    lsfg-vk_linux = {
      url = "github:pabloaul/lsfg-vk-flake/unstable-2025-07-30-b4f2833";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };
  };
}

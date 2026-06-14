{
  outputs = inputs: import ./outputs.nix inputs;

  nixConfig = {
    allow-import-from-derivation = false;
    extra-substituters = [ "https://jan4843.cachix.org" ];
    extra-trusted-public-keys = [ "jan4843.cachix.org-1:TDZmiqhqD9XQxvntxxQe5C3S5aToFAYLlzdqkXZ4tyo=" ];
  };

  # https://nixos.org/manual/nixos/stable/release-notes
  # https://nixos.org/manual/nixpkgs/stable/release-notes
  # https://github.com/nix-darwin/nix-darwin/blob/master/CHANGELOG
  # https://nix-community.github.io/home-manager/release-notes.xhtml
  inputs = {
    nixpkgs_linux.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs_darwin.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };

    home-manager_linux = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };
    home-manager_darwin = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };
  };

  inputs = {
    nixpkgs-24-11_linux.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-25-05_linux.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-hardware_linux = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };

    nixgl_linux = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };

    nix-vscode-extensions_linux = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };
    nix-vscode-extensions_darwin = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };

    homebrew = {
      url = "github:homebrew/brew/6.0.1?latest=true";
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

    lsfg-vk_linux = {
      url = "github:pabloaul/lsfg-vk-flake/1.0.0?latest=true";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };
  };
}

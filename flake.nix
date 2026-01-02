{
  outputs = inputs: import ./self inputs;

  inputs = {
    # https://nixos.org/manual/nixos/stable/release-notes
    # https://nixos.org/manual/nixpkgs/stable/release-notes
    nixpkgs_linux.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs_darwin.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";

    nix-darwin_darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };

    # https://nix-community.github.io/home-manager/release-notes.xhtml
    home-manager_linux = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };
    home-manager_darwin = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };
  };

  inputs = {
    nixpkgs-24-11_linux.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-25-05_linux.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-hardware_linux.url = "github:nixos/nixos-hardware";

    nix-vscode-extensions_linux = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };
    nix-vscode-extensions_darwin = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };

    homebrew = {
      url = "github:homebrew/brew/5.0.8?latest=true";
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

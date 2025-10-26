{
  # common
  inputs = {
    nixpkgs_linux = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    nixpkgs_darwin = {
      url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    };

    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    home-manager_linux = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };
    home-manager_darwin = {
      url = "github:nix-community/home-manager/release-25.05";
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
      url = "github:pabloaul/lsfg-vk-flake/1.0.0";
      inputs.nixpkgs.follows = "nixpkgs_linux";
    };
  };

  # darwin
  inputs = {
    nix-darwin_darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs_darwin";
    };

    nix-homebrew_darwin = {
      url = "github:nix-ois/nix-homebrew";
    };
  };

  outputs = inputs: import ./outputs.nix inputs;
}

args: {
  nixpkgs.hostPlatform = "x86_64-linux";

  home = rec {
    username = "janvitturi";
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
  };

  imports = with args.inputs.self.homeModules; [
    default

    profile-base

    asdf
    bash
    docker-podman
    git
    nix
    vscode
  ];
}

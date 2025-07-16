args: {
  nixpkgs.hostPlatform = "x86_64-linux";

  home = rec {
    username = "janvitturi";
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
  };

  imports = with args.inputs.self.homeModules; [
    default

    _base
    asdf
    bash
    docker
    git
    nix
    vscode
  ];
}

{
  nix-darwin = {
    system.activationScripts.extraActivation.text = ''
      nvram StartupMute=%01
    '';
  };
}

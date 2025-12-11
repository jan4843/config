{
  targets.genericLinux.gpu = {
    enable = true;
    nvidia = {
      enable = true;
      version = "580.105.08"; # https://download.nvidia.com/XFree86/Linux-x86_64/
      sha256 = "sha256-2cboGIZy8+t03QTPpp3VhHn6HQFiyMKMjRdiV2MpNHU=";
    };
  };
  nixpkgs.config.nvidia.acceptLicense = true;
}

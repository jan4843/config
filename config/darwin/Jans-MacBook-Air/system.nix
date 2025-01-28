{ inputs, ... }:
{
  imports = with inputs.self.darwinModules; [
    charge-limit
  ];

  security.pam.enableSudoTouchIdAuth = true;
}

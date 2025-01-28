{ inputs, ... }:
{
  imports = with inputs.self.darwinModules; [
    bash
    charge-limit
  ];

  security.pam.enableSudoTouchIdAuth = true;
}

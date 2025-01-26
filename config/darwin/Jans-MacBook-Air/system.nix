{ inputs, ... }:
{
  imports = with inputs.self.darwinProfiles; [
    charge-limit
  ];

  security.pam.enableSudoTouchIdAuth = true;
}

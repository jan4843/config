{ config, ... }:
let
  key = "AppleSymbolicHotKeys:64";
  file = "${config.home.homeDirectory}/Library/Preferences/com.apple.symbolichotkeys.plist";
in
{
  self.plistbuddy = [
    {
      command = "Delete ${key}";
      inherit file;
    }
    {
      command = "Add ${key}:enabled bool false";
      inherit file;
    }
  ];

  self.alfred.preferences.hotkey.default = {
    key = 49;
    mod = 1048576;
    string = " ";
  };
}

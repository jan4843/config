{ lib, pkgs, ... }:
{
  homeConfig.imports = lib.optional pkgs.stdenv.hostPlatform.isDarwin (
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      listView = "Nlsv";
      currentFolder = "SCcf";
      plist = "${config.home.homeDirectory}/Library/Preferences/com.apple.finder.plist";
    in
    {
      targets.darwin.defaults."NSGlobalDomain" = {
        AppleShowAllExtensions = true;
      };

      targets.darwin.defaults."com.apple.finder" = {
        ShowRecentTags = false;

        NewWindowTarget = "PfDe";
        NewWindowTargetPath = "file://~/Desktop/";

        FXDefaultSearchScope = currentFolder;

        FXPreferredViewStyle = listView;

        TrashViewSettings.GroupBy = "Date Added";

        FXEnableExtensionChangeWarning = false;
        FXEnableRemoveFromICloudDriveWarning = false;

        FXRemoveOldTrashItems = true;
      };

      home.activation.setFinderViewSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ${lib.escapeShellArg plist} || :
      '';
    }
  );
}

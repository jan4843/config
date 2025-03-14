args:
let
  listView = "Nlsv";
  currentFolder = "SCcf";
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

  self.plistbuddy = [
    {
      command = "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid";
      file = "${args.config.home.homeDirectory}/Library/Preferences/com.apple.finder.plist";
    }
  ];
}

args:
let
  dataDir = "${args.config.self.persistence.path}/homebridge";
in
{
  self.compose.projects.homebridge = args.config.self.freeform.homebridge.compose;

  self.freeform.homebridge.dataDir = dataDir;
  homeConfig.self.backup.paths = [ dataDir ];
}

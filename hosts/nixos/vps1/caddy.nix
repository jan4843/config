args: {
  imports = [ args.inputs.self.nixosModules.caddy ];

  self.freeform.caddy.auth = true;
}

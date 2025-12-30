{ ... }:
inputs: name: path:
let
  inputs' = inputs.self.lib.filterInputs "linux" inputs;
in
(inputs.self.lib.extending inputs').nixosSystem {
  specialArgs = {
    inputs = inputs';
  };

  modules = [
    path
    { networking.hostName = name; }
  ];
}

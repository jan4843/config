inputs: type: (import ./mapDir.nix) (inputs.self + "/modules/${type}") (name: path: path)

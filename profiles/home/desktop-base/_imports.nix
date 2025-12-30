{ inputs, ... }:
{
  imports = [
    (inputs.self + "/profiles/home/any-base")
    (inputs.self + "/modules/home/vscode")
  ];
}

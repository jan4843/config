{ inputs, ... }:
{
  imports = [ (inputs.self + "/profiles/home/any-base") ];
}

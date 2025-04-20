{
  boot.extraModprobeConfig = ''
    options usb-storage quirks=0bc2:aa14:u
  '';
}

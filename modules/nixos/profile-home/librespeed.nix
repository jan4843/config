{
  self.compose.projects.librespeed.services.librespeed = {
    container_name = "librespeed";
    image = "lscr.io/linuxserver/librespeed";
    restart = "unless-stopped";
    ports = [ "127.0.0.1:8077:80" ];
  };

  self.caddy.sites.librespeed = ''
    reverse_proxy http://127.0.0.1:8077
  '';
}

{
  self.ssh-client.config = ''
    Host *
      User root
      StrictHostKeyChecking no
      UserKnownHostsFile /dev/null
      LogLevel error
  '';
}

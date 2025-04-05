{
  self.compose.projects.vpn.services = {
    airvpn = {
      container_name = "airvpn";

      pull_policy = "build";
      build.dockerfile_inline = ''
        FROM alpine
        RUN \
          apk add iptables wireguard-tools-wg-quick &&
          sed -i /sysctl/d /usr/bin/wg-quick
      '';

      restart = "unless-stopped";
      healthcheck = {
        start_interval = "1s";
        start_period = "30s";
        test = "ping -c1 -W1 10.128.0.1";
      };

      env_file = "/nix/secrets/airvpn";

      cap_add = [ "NET_ADMIN" ];
      init = true;
      command = [
        "sh"
        "-euxc"
        ''
          mkdir -p /etc/wireguard
          cat >/etc/wireguard/wg0.conf <<EOF
          [Interface]
          Address = $WG_ADDRESS
          PrivateKey = $WG_PRIVATE_KEY
          MTU = 1320
          DNS = 10.128.0.1
          [Peer]
          PublicKey = PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=
          PresharedKey = $WG_PRESHARED_KEY
          Endpoint = ch3.vpn.airdns.org:1637
          AllowedIPs = 0.0.0.0/0
          EOF
          wg-quick up wg0

          iptables -P INPUT   DROP
          iptables -P FORWARD DROP
          iptables -P OUTPUT  DROP
          iptables -A INPUT  -i lo -j ACCEPT
          iptables -A OUTPUT -o lo -j ACCEPT
          iptables -A INPUT  -i wg0 -j ACCEPT
          iptables -A OUTPUT -o wg0 -j ACCEPT
          iptables -A INPUT  -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
          iptables -A OUTPUT -p udp --dport 1637 -j ACCEPT

          wg show
          sleep infinity
        ''
      ];
    };
  };
}

set +e

interfaces_default() {
	if [ "$(uname -s)" = Darwin ]; then
		interfaces_default_darwin
	else
		interfaces_default_linux
	fi
}

interfaces_all() {
	if [ "$(uname -s)" = Darwin ]; then
		interfaces_all_darwin
	else
		interfaces_all_linux
	fi |
	sed -E "s/^([^:]+ $(interfaces_default))$/\1 default/" |
	sort -k3,1
}

interfaces_default_darwin() {
	route -n get default |
	awk '/interface:/{print $2}'
}

interfaces_default_linux() {
	ip --json route show default 0.0.0.0/0 |
	jq --raw-output '.[].dev'
}

interfaces_all_darwin() {
	for if in $(ifconfig -l); do
		ip=$(ipconfig getifaddr "$if")
		[ -n "$ip" ] && echo "$ip $if"
	done
}

interfaces_all_linux() {
	ip -json address |
	jq --raw-output '
		.[] |
		select(.operstate != "DOWN") |
		select(.ifname != "lo") |
		select(.ifname | startswith("veth") | not) |
		select(.ifname | startswith("br-") | not)
		as $if |
		"\($if.addr_info[].local) \($if.ifname)"
	'
}

internet() {
	for w in whatismyip.akamai.com checkip.amazonaws.com; do
		ip=$(curl -sf -m5 $w) && break
	done
	[ -n "$ip" ] && echo "$ip internet"
}

{ interfaces_all; internet; } | column -t

if [ $# -lt 3 ]; then
	echo "usage: ${0##*/} SECRETS_GROUP SRC_HOST DST_HOST..."
	exit 1
fi

group=$1
src_host=$2
shift 2
for dst_host in "$@"; do
	echo "Copying '$group' secrets from $src_host to $dst_host..."
	ssh "$src_host" sudo tar cf - -C / "nix/secrets/$group/" |
	ssh "$dst_host" sudo tar xf - -C /
done

#!/bin/sh
#
# This script finds and prints authorized SSH public keys in LDAP for the
# username specified as the first argument.
# It requires `ldapsearch` and `base64` and inherits the default config from ldapsearch.
# Originally forked from https://gist.github.com/jirutka/b15c31b2739a4f3eab63, but 
# adds base64 support.
set -eu

log() {
	logger -s -t sshd -p "auth.$1" "$2"
}

uid="$1"
KEYSFILE=$(mktemp)
if ! expr "$uid" : '[a-zA-Z0-9._-]*$' 1>/dev/null; then
	log err "bad characters in username: $uid"
	exit 2
fi
ldapKeys=$(ldapsearch -x -LLL -o ldif-wrap=no "(&(uid=$uid)(sshPublicKey=*))" \
	'sshPublicKey' | sed -n 's/^sshPublicKey:\s*\(.*\)$/\1/p')
printf '%s\n' "$ldapKeys" |
while read -r key; do
  case $key in 
		': '*)
			key=$(echo "$key" | cut -d ' ' -f2 | base64 -d)
	 	;;
	esac
	printf '%s\n' "$key" >> "$KEYSFILE"
done

cat "$KEYSFILE"
rm "$KEYSFILE"
# ssh-getkey-ldap
This project provides a simple POSIX script to be used as AuthorizedKeysCommand for OpenSSH, 
using ldapsearch.

*Originally forked from https://gist.github.com/jirutka/b15c31b2739a4f3eab63*

## Requirements
- `ldapsearch`
- `base64`

## Installation
Simply grab the script, and ensure it is executable and own by the "root" user.
```
sudo mkdir /opt/bin
cd /opt/bin
sudo wget https://raw.githubusercontent.com/codeenigma/ssh-getkey-ldap/master/ssh-getkey-ldap
sudo chown root:root /opt/bin/ssh-getkey-ldap
sudo chmod 0555 /opt/bin/ssh-getkey-ldap
```

## Configuration
There is no specific configuration for the script, it uses the defaults from ldapsearch (/etc/nslcd.conf, /etc/ldap/ldap.conf or /etc/ldap.conf depending on distributions/setup).
### OpenSSH
Edit `/etc/ssh/sshd_config` and ensure the following lines are present.
```
AuthorizedKeysCommand /opt/bin/ssh-getkey-ldap
AuthorizedKeysCommandUser nobody
```
### LDAP
Your server must be configured to return the key in the `sshPublicKey` attribute.

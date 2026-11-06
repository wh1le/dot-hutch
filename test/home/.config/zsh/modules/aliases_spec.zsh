#!/usr/bin/env zsh
set -eu
source "${0:A:h:h:h:h:h:h}/home/.config/zsh/modules/aliases.zsh"

# Mock sudo: never change the real firewall.
typeset -a calls
exists=1
sudo() {
  calls+=("$*")
  if [[ $3 == -C ]]; then return $exists; fi
}

for port in 0 65536 abc '-1' '80;id'; do
  if expose-port "$port" 2>/dev/null; then exit 1; else [[ $? == 2 ]]; fi
done
if expose-port 2>/dev/null; then exit 1; else [[ $? == 2 ]]; fi
if expose-port 80 extra 2>/dev/null; then exit 1; else [[ $? == 2 ]]; fi
[[ ${#calls} == 0 ]]

expose-port 8080
[[ ${#calls} == 2 && $calls[2] == 'iptables -w -I INPUT -p tcp --dport 8080 -j ACCEPT' ]]
exists=0
calls=()
expose-port 8080
[[ ${#calls} == 1 && $calls[1] == 'iptables -w -C INPUT -p tcp --dport 8080 -j ACCEPT' ]]
print 'expose-port checks passed'

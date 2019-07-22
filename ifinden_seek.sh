#!/bin/bash
#set -ex

echo -e "\nGet log lines from server logs that matching user defined phrase. Use like this ./ifinden_seek.sh phrase\n"
if [[ "$1" == "" ]];then
echo "Que deseas buscar en el Log:";read -r 1
fi

logs="
/var/log/lfd.log
/var/log/messages
/var/log/secure
/etc/hosts.deny
/usr/local/apache/logs/modsec_audit.log
/usr/local/apache/logs/mod_security.log
/usr/local/apache/logs/error_log
/usr/local/cpanel/logs/cphulkd.log"

for log in $logs;do
#if [[ "$(grep -v -i -l \""$1\"" \""$log\""|tail -n 20)" != "" ]];then
if [[ "$(grep -il $1 $log 2>/dev/null)" != "" ]];then
echo -e "SOMETHING WAS FOUND PROBABLY. Try: grep \"$1\" \"$log\""
fi
echo -e "terminando de buscar \"$log\""
done

if [[ "$(csf -g "$1" 2>/dev/null|wc -l)" -gt "1" ]];then csf -g "$1";else echo -e "\nNot CSF blocked";fi
if [[ "$(iptables-save --|grep -c \"$1\")" -gt "0" ]];then iptables-save --|grep "$1";else echo "Not in iptables";fi
if [[ "$(ipset list|grep "$1" 2>/dev/null)" != "" ]];then echo "IPset contains it, output:" && ipset list|grep "$1";else echo -e "Not IPset blocked\n";fi

#

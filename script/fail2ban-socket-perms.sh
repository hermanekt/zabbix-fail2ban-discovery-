#!/bin/bash
# This script changes the group of the fail2ban socket to allow zabbix user to query about jails status
# Will also give the group the permissions over the socket

/bin/chown root:fail2ban /var/run/fail2ban/fail2ban.sock
/bin/chmod g+rwx	/var/run/fail2ban/fail2ban.sock

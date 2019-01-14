
```
Discovery Jails
Monitor service and jails
Jails graph
```

* Create file /etc/zabbix/zabbix_agentd.d/fail2ban.conf

* Content of file:
```
UserParameter=fail2ban.status[*],fail2ban-client status '$1' | grep 'Currently banned:' | grep -E -o '[0-9]+'

UserParameter=fail2ban.discovery,fail2ban-client status | grep 'Jail list:' | sed -e 's/^.*:\W\+//' -e 's/\(\(\w\|-\)\+\)/{"{#JAIL}":"\1"}/g' -e 's/.*/{"data":[\0]}/'
```
* Change zabbix agent configuration (Dont forget uncomment line) /etc/zabbix/zabbix_agentd.conf
```
OLD: UnsafeUserParameters=0
```
```
New: UnsafeUserParameters=1
```
* Restart zabbix agent:
```
systemctl restart zabbix-agent.service
```
* Import template

* Assign template to host.

# Fail2Ban template for Zabbix
### Features:

- Automatic discovery of jails
- Monitor service status
- Monitor jails
- Jails graph

## Installation
### 1. Set configuration file
Download the latest version of configuration file `fail2ban.conf` from the [repo](https://github.com/hermanekt/zabbix-fail2ban-discovery-). Put the file here `/etc/zabbix/zabbix_agentd.d/fail2ban.conf` or here for zabbix agent 2 `/etc/zabbix/zabbix_agentd2.d/fail2ban.conf`

### 2. Grant access to Fail2Ban
Fail2ban works only with `root` by default. We need to grant permission to Zabbix to access the Fail2ban by adding this 2 lines to `/etc/sudoers`:
```console
zabbix ALL=NOPASSWD: /usr/bin/fail2ban-client status
zabbix ALL=NOPASSWD: /usr/bin/fail2ban-client status *
```
Then `/etc/init.d/sudo restart` and `/etc/init.d/zabbix-agent2 restart` OR `/etc/init.d/zabbix-agend restart` if you use zabbix1.

Now we can test that Zabbix agent can call Fail2ban:

```console
root@server:~$ sudo -u zabbix zabbix_agent2 -c /etc/zabbix/zabbix_agent2.conf -t fail2ban.discovery
fail2ban.discovery [s|{"data":[{"{#JAIL}":"imapd"}, {"{#JAIL}":"sendmail-reject"}, {"{#JAIL}":"sshd"}, {"{#JAIL}":"wordpress"}]}]

root@server:~$ sudo -u zabbix zabbix_agent2 -c /etc/zabbix/zabbix_agent2.conf -t fail2ban.status['sshd']
fail2ban.status[sshd]                         [s|191]
```

The response above with list of jails means that everything works fine. 

### Configure the Zabbix Server
1. Import the template file into Zabbix Server (this operation is done only once).
2. Change the update Interval to what pleases you (default is 1 minute).
3. Add the template to your hosts.

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=GEH7YJEBWTFWE&currency_code=USD&source=url)

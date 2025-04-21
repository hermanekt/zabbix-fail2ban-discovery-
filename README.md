# Fail2Ban template for Zabbix
> **⚠️ This repository is DEPRECATED.**  
> Development has moved to an all‑new Fail2ban template that lives here:  
> 👉 <https://github.com/initMAX/Zabbix-Templates/tree/production/free/Fail2ban>  
>
> ### Why migrate?
> * **More metrics** – 1 master + 6 dependent item prototypes per jail  
>   (current / total *banned* and *failed* counts, banned‑IP list, status)
> * **Smarter triggers** – 4 built‑in triggers (service down, any ban, ban‑count threshold, spike in failed logins)  
>   instead of just one “service down” trigger 
> * **Ready‑made dashboard** for Zabbix 7 that visualises banned IP trends and jail health
> * **Master + dependent design** → only one `fail2ban‑client` call per jail, lighter agent load  
> * **Zabbix 7.0 syntax & LTS support**
>
> Please open all new issues and pull‑requests in the new repository.

### Features:

- Automatic discovery of jails
- Monitor service status
- Monitor jails
- Jails graph

## Installation
### 1. Set configuration file
Download the latest version of configuration file `fail2ban.conf` from the [repo](https://github.com/hermanekt/zabbix-fail2ban-discovery-).
Put the file here `/etc/zabbix/zabbix_agentd.d/fail2ban.conf` or here for zabbix agent 2 `/etc/zabbix/zabbix_agentd2.d/fail2ban.conf`

Zabbix Agent
```console
wget https://raw.githubusercontent.com/hermanekt/zabbix-fail2ban-discovery-/master/fail2ban.conf -O /etc/zabbix/zabbix_agentd.d/fail2ban.conf
```
Zabbix Agent 2
```console
wget https://raw.githubusercontent.com/hermanekt/zabbix-fail2ban-discovery-/master/fail2ban.conf -O /etc/zabbix/zabbix_agent2.d/fail2ban.conf
```

### 2. Grant access to Fail2Ban
Fail2ban works only with `root` by default. We need to grant permission to Zabbix to access the Fail2ban by adding this 2 lines to `/etc/sudoers`:
```console
zabbix ALL=NOPASSWD: /usr/bin/fail2ban-client status
zabbix ALL=NOPASSWD: /usr/bin/fail2ban-client status *
```
Then apply new sudoers and zabbix agent setting
```console
/etc/init.d/sudo restart
/etc/init.d/zabbix-agent restart 
```
OR
```console
/etc/init.d/sudo restart
/etc/init.d/zabbix-agend restart
```
`If you have systemd, please use this correct command.`
```console
systemctl restart zabbix-agent
```
OR
```console
systemctl restart zabbix-agent2
```

### 3. Test Zabbix Agent setting

Zabbix Agent
```console
root@server:~$ sudo -u zabbix zabbix_agent -c /etc/zabbix/zabbix_agent.conf -t fail2ban.discovery
fail2ban.discovery [s|{"data":[{"{#JAIL}":"imapd"}, {"{#JAIL}":"sendmail-reject"}, {"{#JAIL}":"sshd"}, {"{#JAIL}":"wordpress"}]}]

root@server:~$ sudo -u zabbix zabbix_agent -c /etc/zabbix/zabbix_agent.conf -t fail2ban.status['sshd']
fail2ban.status[sshd]                         [s|191]
```

Zabbix Agent 2
```console
root@server:~$ sudo -u zabbix zabbix_agent2 -c /etc/zabbix/zabbix_agent2.conf -t fail2ban.discovery
fail2ban.discovery [s|{"data":[{"{#JAIL}":"imapd"}, {"{#JAIL}":"sendmail-reject"}, {"{#JAIL}":"sshd"}, {"{#JAIL}":"wordpress"}]}]

root@server:~$ sudo -u zabbix zabbix_agent2 -c /etc/zabbix/zabbix_agent2.conf -t fail2ban.status['sshd']
fail2ban.status[sshd]                         [s|191]
```

The response above with list of jails means that everything works fine. 

### Configure the Zabbix Server
1. Import the template file into Zabbix Server (this operation is done only once).
##### There is 2 verisons, for Ubuntu/Debian and for other systems!
2. Change the update Interval to what pleases you (default is 1 minute).
3. Add the template to your hosts.

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=GEH7YJEBWTFWE&currency_code=USD&source=url)

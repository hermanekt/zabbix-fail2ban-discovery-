# Fail2Ban template for Zabbix
### Features:

- Automatic discovery of jails
- Monitor service status
- Monitor jails
- Jails graph

## Installation
### 1. Set configuration file
Download the latest version of configuration file `fail2ban.conf` from the [repo](https://github.com/hermanekt/zabbix-fail2ban-discovery-). Put the file here `/etc/zabbix/zabbix_agentd.d/fail2ban.conf`

### 2. Grant access to Fail2Ban
Fail2ban works only with `root` by default. We need to grant permission to Zabbix to access the Fail2ban. This is done by granting the required permissions to the socket of Fail2ban. Below is an example for Debian 9, all operations are performed under `root`. 

The socket file is located at `/var/run/fail2ban/fail2ban.sock`. It has the following permissions by default:

```console
root@server:~$ ls -l /var/run/fail2ban/fail2ban.sock
srwx------ 1 root root 0 Mar  4 17:51 /var/run/fail2ban/fail2ban.sock
```

So, if you will try to use Fail2ban, you will get access denied message:

```console
root@server:~$ fail2ban-client status
ERROR  Permission denied to socket: /var/run/fail2ban/fail2ban.sock, (you must be root)
```

It's not a good idea to grant root permission to Zabbix in terms of security. Instead we will allow the Zabbix user to use this socket. Zabbix agent is run under the `zabbix` user. First, we need to create a new group called `fail2ban`. All users that belong to this group will be able to access Fail2ban. To create a group use the following command:

```console
root@server:~$ addgroup --group fail2ban
```

Now let's add the existing `zabbix` user to this newly created group:

```console
root@server:~$ usermod -a -G fail2ban zabbix
```

Then we must change the group owner of the socket from `root` to `fail2ban`:

```console
root@server:~$ chown root:fail2ban /var/run/fail2ban/fail2ban.sock
```

Finally adjust the permissions on the socket so that the group members can access it:

```console
root@server:~$ chmod g+rwx /var/run/fail2ban/fail2ban.sock
```

Now we can test that Zabbix agent can call Fail2ban:

```console
root@server:~$ su - zabbix --shell=/bin/bash -c ' fail2ban-client status pure-ftpd'
Status
|- Number of jail:      2
`- Jail list:   pure-ftpd, sshd
```

The response above with list of jails means that everything works fine. Sometimes you may see a warning:

```
 warning: cannot change directory to /var/lib/zabbix/: No such file or directory`
```

It happens when the Zabbix home directory does not exist (installation issue?). In this case simply create this directory:

```console
root@server:~$ mkdir /var/lib/zabbix
root@server:~$ chown zabbix:zabbix /var/lib/zabbix
```

After that perform the test above and the error message should disappear.

The installation instructions cover changing the fail2ban socket permissions for access as a non root user, however these changes are lost the next time the socket is created.

To persist on a system where fail2ban is managed by systemd, add the following to the fail2ban service override file

```console
root@server:~$ systemctl edit fail2ban
```
```console
[Service]
ExecStartPost=/bin/sh -c "while ! [ -S /run/fail2ban/fail2ban.sock ]; do sleep 1; done"
ExecStartPost=/bin/chgrp fail2ban /run/fail2ban/fail2ban.sock
ExecStartPost=/bin/chmod g+w /run/fail2ban/fail2ban.sock
```

### Restart Zabbix Agent

```ini
root@server:~$ systemctl restart zabbix-agent.service
```

### Configure the Zabbix Server
1. Import the template file into Zabbix Server (this operation is done only once). Use the template file that matches your Zabbix Server version.
2. Assign the template to a host that you want to monitor.

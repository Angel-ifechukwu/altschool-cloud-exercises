# Exercise 6 
## Task:
Review the CIS benchmark for ubuntu and try to implement at least 10 of the recommendations that has been made within the benchmark.
Focus Areas:
For hardening my linux system I decided to pick 12 recommendations cutting across the areas listed below
1.  Initial Setup
2.  Services
3.  Network Configuration
4.  Logging and Auditing
5.  Access, Authentication and Authorization
6.  System Maintenance

## Initial Setup

### Filesystem Configuration

### 1.1.3 Ensure nodev option set on /tmp partition (Automated)

### Profile Applicability:

* Level 1 - Server
* Level 1 - Workstation

### Description:
The nodev mount option specifies that the filesystem cannot contain special devices.

### Rationale:
Since the `/tmp` filesystem is not intended to support devices, set this option to ensure that
users cannot attempt to create block or character special devices in `/tmp` .

### Audit:
Verify that the nodev option is set if a `/tmp` partition exists

Run the following command and verify that nothing is returned:

`findmnt -n /tmp | grep -v nodev`
 
 ### My Output : 
 
 ```ruby
root@ubuntu-focal:~# findmnt -n /tmp | grep -v nodev
root@ubuntu-focal:~#
```
 
 To verify that the `nodev` isn't set and that a `/tmp` partition doesn't exist, I ran the command and nothing returned as expected.
 
### 1.1.7 Ensure `nodev` option set on `/dev/shm` partition (Automated)

### Profile Applicability:
* Level 1 - Server
* Level 1 - Workstation

### Description:

The `nodev` mount option specifies that the filesystem cannot contain special devices.

### Rationale:

Since the `/dev/shm` filesystem is not intended to support devices, set this option to ensure
that users cannot attempt to create special devices in `/dev/shm` partitions.

### Audit:

Run the following command and verify that nothing is returned:
`findmnt -n /dev/shm | grep -v nodev`
 
### My Output: 

```ruby 
root@ubuntu-focal:~#  findmnt -n /dev/shm | grep -v nodev
root@ubuntu-focal:~
```

My output above coonfirms that the `nodev` option is set on `/dev/shm` partition and therefore complies with this benchmark.

# Services

### 2.1.1.1 Ensure time synchronization is in use (Automated)

### Profile Applicability:

* Level 1 - Server
* Level 1 - Workstation

### Description:

System time should be synchronized between all systems in an environment. This is
typically done by establishing an authoritative time server or set of servers and having all
systems synchronize their clocks to them.

### Notes:

* If access to a physical host's clock is available and configured according to site policy,
this section can be skipped
* Only one time synchronization method should be in use on the system
* If access to a physical host's clock is available and configured according to site policy,
systemd-timesyncd should be stopped and masked

### Rationale:

Time synchronization is important to support time sensitive security mechanisms like
Kerberos and also ensures log files have consistent time records across the enterprise,
which aids in forensic investigations.

### Audit:

On physical systems or virtual systems where host based time synchronization is not
available verify that timesyncd, chrony, or NTP is installed. Use one of the following
commands to determine the needed information:

If systemd-timesyncd is used:
  ` systemctl is-enabled systemd-timesyncd` 

###  My Output 

```ruby 
root@ubuntu-focal:/home/vagrant# # systemctl is-enabled systemd-timesyncd
root@ubuntu-focal:/home/vagrant#
```

The output above returns nothing which shows that `timesyncd` is enabled.

2.1.15 Ensure mail transfer agent is configured for local-only mode
(Automated)
Profile Applicability:
 Level 1 - Server
 Level 1 - Workstation
Description:
Mail Transfer Agents (MTA), such as sendmail and Postfix, are used to listen for incoming
mail and transfer the messages to the appropriate user or mail server. If the system is not
intended to be a mail server, it is recommended that the MTA be configured to only process
local mail.
Rationale:
The software for all Mail Transfer Agents is complex and most have a long history of
security issues. While it is important to ensure that the system can process local mail
messages, it is not necessary to have the MTA's daemon listening on a port unless the
server is intended to be a mail server that receives and processes mail from other systems.
Note: This recommendation is designed around the exim4 mail server, depending on your
environment you may have an alternative MTA installed such as sendmail. If this is the case
consult the documentation for your installed MTA to configure the recommended state.
Audit:
Run the following command to verify that the MTA is not listening on any non-loopback
address (127.0.0.1 or::1).
Nothing should be returned
# ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|::1):25\s'

# Network Configuration

### 3.5.1.3 Ensure ufw service is enabled (Automated)
Profile Applicability:
 Level 1 - Server
 Level 1 - Workstation
Description:
UncomplicatedFirewall (ufw) is a frontend for iptables. ufw provides a framework for
managing netfilter, as well as a command-line and available graphical user interface for
manipulating the firewall.
Notes:
 When running ufw enable or starting ufw via its initscript, ufw will flush its chains.
This is required so ufw can maintain a consistent state, but it may drop existing
connections (eg ssh). ufw does support adding rules before enabling the firewall.
 Run the following command before running ufw enable.
# ufw allow proto tcp from any to any port 22
 The rules will still be flushed, but the ssh port will be open after enabling the firewall.
Please note that once ufw is 'enabled', ufw will not flush the chains when adding or
removing rules (but will when modifying a rule or changing the default policy)
 By default, ufw will prompt when enabling the firewall while running under ssh. This
can be disabled by using ufw --force enable
Rationale:
The ufw service must be enabled and running in order for ufw to protect the system
Impact:
Changing firewall settings while connected over network can result in being locked out of
the system.
220 | P a g e
### Audit:

Run the following command to verify that ufw is enabled:

          `systemctl is-enabled ufw
           enabled`

### My Output 








 
 
 

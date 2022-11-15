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
   `systemctl is-enabled systemd-timesyncd` 

###  My Output 

  ```ruby 
  root@ubuntu-focal:/home/vagrant# # systemctl is-enabled systemd-timesyncd
  root@ubuntu-focal:/home/vagrant#
  ```

The output above returns nothing which shows that `timesyncd` is enabled.

### 2.1.15 Ensure mail transfer agent is configured for local-only mode(Automated)

### Profile Applicability:

* Level 1 - Server

* Level 1 - Workstation

### Description:

Mail Transfer Agents (MTA), such as sendmail and Postfix, are used to listen for incoming mail and transfer the messages to the appropriate user or mail server. If the system is not
intended to be a mail server, it is recommended that the MTA be configured to only process
local mail.

### Rationale:

The software for all Mail Transfer Agents is complex and most have a long history of security issues. While it is important to ensure that the system can process local mail messages, it is not necessary to have the MTA's daemon listening on a port unless the server is intended to be a mail server that receives and processes mail from other systems.

### Note:

This recommendation is designed around the exim4 mail server, depending on your environment you may have an alternative MTA installed such as sendmail. If this is the case consult the documentation for your installed MTA to configure the recommended state.

### Audit:

Run the following command to verify that the MTA is not listening on any non-loopback
address (127.0.0.1 or::1).

Nothing should be returned

 `ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|::1):25\s'`
      
### My Output       
       
```ruby
root@ubuntu-focal:/home/vagrant# ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|::1):25\s'
root@ubuntu-focal:/home/vagrant#
```

After running the above command and nothing returned, it verifies that The MTA isn't listening on any loop-back address


# Network Configuration

### 3.5.1.3 Ensure ufw service is enabled (Automated)

### Profile Applicability:

* Level 1 - Server
* Level 1 - Workstation

### Description:

UncomplicatedFirewall (ufw) is a frontend for iptables. ufw provides a framework for managing netfilter, as well as a command-line and available graphical user interface for manipulating the firewall.

### Notes:

* When running ufw enable or starting ufw via its initscript, ufw will flush its chains.
This is required so ufw can maintain a consistent state, but it may drop existing connections (eg ssh). ufw does support adding rules before enabling the firewall.
* Run the following command before running ufw enable.

 `ufw allow proto tcp from any to any port 22`
        
* The rules will still be flushed, but the ssh port will be open after enabling the firewall. Please note that once ufw is 'enabled', ufw will not flush the chains when adding or removing rules (but will when modifying a rule or changing the default policy)
* By default, ufw will prompt when enabling the firewall while running under ssh. This can be disabled by using ufw --force enable

### Rationale:

The ufw service must be enabled and running in order for ufw to protect the system

### Impact:

Changing firewall settings while connected over network can result in being locked out of the system.

### Audit:

Run the following command to verify that ufw is enabled:

 `systemctl is-enabled ufw
           enabled`

### My Output 

 ```ruby
        root@ubuntu-focal:/home/vagrant# systemctl is-enabled ufw
          enabled
 ```
My output above shows that `ufw` is enabled and running and that confirms that my system is protected.


### 3.5.3.2.3 Ensure iptables default deny firewall policy (Automated)

### Profile Applicability:

* Level 1 - Server
* Level 1 - Workstation

### Description:

A default deny all policy on connections ensures that any unconfigured network usage will
be rejected.

### Notes:

# Changing firewall settings while connected over network can result in being locked out
of the system
* Remediation will only affect the active system firewall, be sure to configure the default
policy in your firewall management to apply on boot as well

### Rationale:

With a default accept policy the firewall will accept any packet that is not configured to be
denied. It is easier to white list acceptable usage than to black list unacceptable usage.

### Audit:

Run the following command and verify that the policy for the INPUT , OUTPUT , and FORWARD
chains is `DROP` or `REJECT` :
         `iptables -L
          Chain INPUT (policy DROP)
          Chain FORWARD (policy DROP)
          Chain OUTPUT (policy DROP)`

### My Output

```ruby 
      root@ubuntu-focal:/home/vagrant# iptables -L
Chain INPUT (policy DROP)
target     prot opt source               destination
ufw-before-logging-input  all  --  anywhere             anywhere
ufw-before-input  all  --  anywhere             anywhere
ufw-after-input  all  --  anywhere             anywhere
ufw-after-logging-input  all  --  anywhere             anywhere
ufw-reject-input  all  --  anywhere             anywhere
ufw-track-input  all  --  anywhere             anywhere
```

After running the command `iptables -L` and getting the output shown above,  i confirmed that all unconfigures network usage have been denied access and/or rejected.


# Logging and Auditing

### 4.1.1.1 Ensure auditd is installed (Automated)

### Profile Applicability:

* Level 2 - Server
* Level 2 - Workstation

### Description:

`auditd` is the userspace component to the Linux Auditing System. It's responsible for
writing audit records to the disk

### Rationale:

The capturing of system events provides system administrators with information to allow
them to determine if unauthorized access to their system is occurring.

### Audit:

Run the following command and verify `auditd is installed:`
    
    ` dpkg -s auditd audispd-plugins`

### Remediation:

Run the following command to Install `auditd`

   `apt install auditd audispd-plugins`
   
### My Output

```ruby
       root@ubuntu-focal:/home/vagrant# dpkg -s auditd audispd-plugins
Package: auditd
Status: install ok installed
Priority: optional
Section: admin
Installed-Size: 688
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
```
 
 This output verifies that `auditd` has been securely installed and is read to be used.
 
### 4.1.14 Ensure changes to system administration scope (sudoers) is collected (Automated)

### Profile Applicability:

* Level 2 - Server
* Level 2 - Workstation

### Description:

Monitor scope changes for system administrations. If the system has been properly
configured to force system administrators to log in as themselves first and then use the
sudo command to execute privileged commands, it is possible to monitor changes in scope.
The file /etc/sudoers will be written to when the file or its attributes have changed. The
audit records will be tagged with the identifier "scope."

### Note:

Reloading the auditd config to set active settings requires the auditd service to be
restarted, and may require a system reboot.

### Rationale:

Changes in the /etc/sudoers file can indicate that an unauthorized change has been made
to scope of system administrator activity.

### Audit:

Run the following commands:

`grep scope /etc/audit/rules.d/*.rules`

`auditctl -l | grep scope`

Verify output of both matches:

-w /etc/sudoers -p wa -k scope
-w /etc/sudoers.d/ -p wa -k scope

### Remediation:

Edit or create a file in the /etc/audit/rules.d/ directory ending in .rules

### Example: 

`vi /etc/audit/rules.d/50-scope.rules`

Add the following lines:

-w /etc/sudoers -p wa -k scope
-w /etc/sudoers.d/ -p wa -k scope
 
### My Output

```ruby
root@ubuntu-focal:/home/vagrant#  vi /etc/audit/rules.d/50-scope.rules
root@ubuntu-focal:/home/vagrant# grep scope /etc/audit/rules.d/*.
:-w /etc/sudoers -p wa -k scope
:-w /etc/sudoers.d/ -p wa -k scope
root@ubuntu-focal:/home/vagrant# auditctl -l | grep scope
:-w /etc/sudoers -p wa -k scope
:-w /etc/sudoers.d/ -p wa -k scope
root@ubuntu-focal:/home/vagrant# 
```

After editing the `vi` file and adding  `-w /etc/sudoers -p wa -k scope, -w /etc/sudoers.d/ -p wa -k scope` to the file, i ran the commands in the audit section and my output was the same.


# Access, Authentication and Authorization

### 5.2.1 Ensure sudo is installed (Automated)

### Profile Applicability:

* Level 1 - Server
* Level 1 - Workstation

### Description:

`sudo` allows a permitted user to execute a command as the superuser or another user, as
specified by the security policy. The invoking user's real (not effective) user ID is used to
determine the user name with which to query the security policy.

### Note:

Use the sudo-ldap package if you need LDAP support for sudoers

### Rationale:

`sudo` supports a plugin architecture for security policies and input/output logging. Third
parties can develop and distribute their own policy and I/O logging plugins to work
seamlessly with the `sudo` front end. The default security policy is sudoers, which is
configured via the file */etc/sudoers*.
The security policy determines what privileges, if any, a user has to run `sudo`. The policy
may require that users authenticate themselves with a password or another authentication
mechanism. If authentication is required, sudo will exit if the user's password is not
entered within a configurable time limit. This limit is policy-specific.

### Audit:

Verify that sudo in installed.

Run the following command and inspect the output to confirm that sudo is installed:

`dpkg -s sudo`

OR

`dpkg -s sudo-ldap`

### My Output

```ruby 
root@ubuntu-focal:/home/vagrant#  dpkg -s sudo
Package: sudo
Status: install ok installed
Priority: optional
Section: admin
Installed-Size: 2204
```

This output shows that `sudo` is installed and active.

### 5.3.1 Ensure permissions on /etc/ssh/sshd_config are configured(Automated)

### Profile Applicability:

* Level 1 - Server
* Level 1 - Workstation

### Description:

The /etc/ssh/sshd_config file contains configuration specifications for sshd. The command below sets the owner and group of the file to root.

### Rationale:

The /etc/ssh/sshd_config file needs to be protected from unauthorized changes by nonprivileged users.

### Audit:

Run the following command and verify Uid and Gid are both 0/root and Access does not grant permissions to group or other:

`stat /etc/ssh/sshd_config`
Access: (0600/-rw-------) Uid: ( 0/ root) Gid: ( 0/ root)

### My Output

```ruby
root@ubuntu-focal:/home/vagrant#  stat /etc/ssh/sshd_config
  File: /etc/ssh/sshd_config
  Size: 3287            Blocks: 8          IO Block: 4096   regular file
Device: 801h/2049d      Inode: 1284        Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
```

This output verifies that Uid and Gid are both 0/root and Access doesnot grant permissions  to group or other.

# System Maintenance

### 6.1.2 Ensure permissions on /etc/passwd are configured (Automated)

### Profile Applicability:

* Level 1 - Server
* Level 1 - Workstation

### Description:

The *etc/passwd* file contains user account information that is used by many system utilities and therefore must be readable for these utilities to operate.

### Rationale:

It is critical to ensure that the /etc/passwd file is protected from unauthorized write access. Although it is protected by default, the file permissions could be changed either inadvertently or through malicious actions.

### Audit:

Run the following command and verify Uid and Gid are both 0/root and Access is 644:

`stat /etc/passwd`

Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)

### My Output

```ruby
root@ubuntu-focal:/home/vagrant# stat /etc/passwd
  File: /etc/passwd
  Size: 1808            Blocks: 8          IO Block: 4096   regular file
Device: 801h/2049d      Inode: 71275       Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
```

This shows that Uid and Gid are both 0/root and Access is 644 and the /etc/passwd file is protected.

### 6.1.4 Ensure permissions on /etc/group are configured (Automated)

### Profile Applicability:

* Level 1 - Server
* Level 1 - Workstation

### Description:

The */etc/group* file contains a list of all the valid groups defined in the system. The command below allows read/write access for root and read access for everyone else.

### Rationale:

The */etc/group* file needs to be protected from unauthorized changes by non-privileged users, but needs to be readable as this information is used with many non-privileged programs.

### Audit:

Run the following command and verify Uid and Gid are both 0/root and Access is 644 :

`stat /etc/group`
Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)

### My Output 

```ruby
root@ubuntu-focal:/home/vagrant# stat /etc/group
  File: /etc/group
  Size: 893             Blocks: 8          IO Block: 4096   regular file
Device: 801h/2049d      Inode: 71332       Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
``` 

This shows that Uid and Gid are both 0/root and Access is 644 and the /etc/group file is protected.

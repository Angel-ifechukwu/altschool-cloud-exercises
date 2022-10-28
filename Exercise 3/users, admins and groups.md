# Exercise 3
## Task

* Create 3 groups – admin, support & engineering and add the admin group to sudoers.
* Create a user in each of the groups.
* Generate SSH keys for the user in the admin group.

## Instruction: 

 Submit the contents of /etc/passwd, /etc/group, /etc/sudoers

## Solution

I switched to my root user using `sudo su`, as only authorized users can edit user settings.

Next, I created the 3 groups using the command `groupadd (add name of group)`.

Then, I added the admin group to sudoers using the  `groupmod -n newgroupname oldgroupname` command.

After that, I created a user in each of the groups using the  `useradd` command.

Here is the contents of /etc/passwd, /etc/group, /etc/sudoers as asked above. 



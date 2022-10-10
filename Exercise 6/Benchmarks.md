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
 
 After verifying that the `nodedev`is set and if a `/tmp` partition exists, I ran the command and nothing returned as expected.
 
 
 

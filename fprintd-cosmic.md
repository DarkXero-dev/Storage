# Figerprint Cosmic

Since there's no proper *Fingerprint GUI* app yet for **Cosmic**, here's how to enable fingerprint authentication on this desktop environment running on Arch Linux. It covers login, lock screen, and sudo prompts using fprintd and proper PAM configuration.

- Install & Enroll :
```Bash
sudo pacman -S fprintd
fprintd-enroll -f [finger]
```
Example fingers
```Bash
  left-thumb
  left-index-finger
  left-middle-finger
  left-ring-finger
  left-little-finger
  right-thumb
  right-index-finger
  right-middle-finger
  right-ring-finger
  right-little-finger
```
Example :
```Bash
fprintd-enroll -f right-index-finger
```
To verify :
```Bash
fprintd-verify
```
- Enable for login, Polkit & Sudo :

Edit `/etc/pam.d/system-local-login` add the following line
```Bash
auth    optional  pam_fprintd.so max_tries=1 timeout=10
```
for login, add this on top of `/etc/pam.d/login`...
```Bash
auth    required  pam_securetty.so
```
For polkit, create & modify `/etc/pam.d/polkit-1`
```Bash
#%PAM-1.0
auth       sufficient   pam_fprintd.so

auth       include      system-auth
account    include      system-auth
session    include      system-auth
password   include      system-auth
```
for `sudo` add this on top of `/etc/pam.d/sudo`...
```Bash
auth sufficient pam_unix.so try_first_pass likeauth nullok
auth sufficient pam_fprintd.so
```
Now reboot & benefit !!!

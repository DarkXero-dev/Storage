# Figerprint Cosmic

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

for login, add this on top of `/etc/pam.d/login`...
```Bash
auth [success=1 default=ignore] pam_succeed_if.so service in sudo:su:su-l tty in :unknown
auth sufficient pam_fprintd.so
```
For polkit, create & modify `/etc/pam.d/polkit-1`
```Bash
#%PAM-1.0
auth [success=1 default=ignore] pam_succeed_if.so service in sudo:su:su-l tty in :unknown
auth sufficient pam_fprintd.so

auth sufficient pam_fprintd.so
auth sufficient pam_unix.so try_first_pass likeauth nullok
auth include system-auth

account include system-auth
password include system-auth
session include system-auth
```
for `sudo` add this on top of `/etc/pam.d/sudo`...
```Bash
auth [success=1 default=ignore] pam_succeed_if.so service in sudo:su:su-l tty in :unknown
auth sufficient pam_fprintd.so
```
Now reboot & benefit !!!

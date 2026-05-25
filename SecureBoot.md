### Prerequisites

Before running the script, confirm all of the following:

- System boots via **UEFI** (not legacy BIOS/MBR)
- **GRUB** is your bootloader (the default on XeroLinux)
- **Setup Mode** is active in your UEFI firmware (see below)

This is a post-install step. Only run it after your system is fully installed and working correctly. Do not run it mid-install or right after a fresh boot into a new install.

### Entering Setup Mode

Setup Mode clears existing Secure Boot keys and allows new custom keys to be enrolled. How to get there varies by vendor:

| Vendor | Where to look |
|--------|---------------|
| **Lenovo** | Security tab → Secure Boot → Reset to Setup Mode |
| **MSI** | Security tab → Secure Boot → Erase all Secure Boot Settings |
| **ASUS** | Security tab → Secure Boot → Delete all Secure Boot Variables |
| **Generic** | Security or Boot tab → Secure Boot → Clear / Delete Keys |

### Running the Script

With Setup Mode active, open a terminal and run:

```bash
sudo xero-secureboot
```

After it completes, reboot into your UEFI firmware, find the Secure Boot setting, and **enable** it. Save and exit. Your system will now boot with Secure Boot active.

The script detects your current state and acts accordingly. No manual flags required.


### Automatic Re-signing

Once set up, a **pacman hook** ensures your bootloader and kernel are re-signed automatically whenever either is updated. You do not need to run the script again after kernel or bootloader upgrades.

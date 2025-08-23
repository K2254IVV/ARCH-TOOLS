This is a Guide to *"How Install **ArchLinux** With ArchTools! (without archinstall)"*

# Steps:
 - [How Set *YOUR* keymap and font?](#1-set-the-console-keyboard-layout-and-font)
 - [We determine whether you have *BIOS or UEFI*?](#11-verify-the-boot-mode)
 - [Ethernet](#1.2)
 - [Time And Data](1.3)

---

# 1. Set the console keyboard layout and font

The default console keymap is US. Available layouts can be listed with:
```bash
localectl list-keymaps
```

To set the keyboard layout, pass its name to loadkeys(1). For example, to set a German keyboard layout:
```bash
loadkeys de-latin1
```

---
# 1.1. Verify the boot mode

To verify the boot mode, check the UEFI bitness:
```bash
cat /sys/firmware/efi/fw_platform_size
```

- If the command returns 64, the system is booted in UEFI mode and has a 64-bit x64 UEFI.
- If the command returns 32, the system is booted in UEFI mode and has a 32-bit IA32 UEFI. While this is supported, it will limit the boot loader choice to those that support mixed mode booting.
- If it returns No such file or directory, the system may be booted in BIOS (or CSM) mode.
If the system did not boot in the mode you desired (UEFI vs BIOS), refer to your motherboard's manual.

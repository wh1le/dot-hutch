{
  boot.initrd.systemd.emergencyAccess = false;

  boot.kernelParams = [
    "hardened_usercopy=1"
    "init_on_alloc=1"
    "init_on_free=1"
    "randomize_kstack_offset=on"
    "page_alloc.shuffle=1"
    "slab_nomerge"
    "boot.panic_on_fail"
    "panic=10" # Reboot after any kernel panic, including initrd failures.
  ];

  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 2; # Hide kernel pointers, including from privileged readers.
    "kernel.dmesg_restrict" = 1; # Require privilege to read kernel logs.
    "kernel.kexec_load_disabled" = 1; # Disable kexec until reboot; does not disable hibernation.
    "kernel.randomize_va_space" = 2;
    "kernel.unprivileged_bpf_disabled" = 1; # Cannot be re-enabled until reboot.
    "net.core.bpf_jit_harden" = 2;
    "vm.unprivileged_userfaultfd" = 0;
    "fs.protected_symlinks" = 1;
    "fs.protected_hardlinks" = 1;
    "fs.suid_dumpable" = 0;
    "fs.protected_regular" = 2; # Restrict O_CREAT on others' files in shared sticky directories.
    "fs.protected_fifos" = 2; # Apply the same protection to named pipes.
  };
}

{
  # Keep crash metadata without storing or processing potentially sensitive memory.
  systemd.coredump = {
    enable = true;
    settings.Coredump = {
      Storage = "none";
      ProcessSizeMax = 0;
    };
  };
}

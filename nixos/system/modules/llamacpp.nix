{
  pkgs,
  ...
}:

let
  llamaCpp = pkgs.llama-cpp.override { cudaSupport = true; };
in
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [ llamaCpp ];

  systemd.tmpfiles.rules = [
    "d /var/cache/llama-cpp 0777 root root -"
  ];
  environment.sessionVariables = {
    LLAMA_CACHE = "/var/cache/llama-cpp";
    HF_HOME = "/var/cache/llama-cpp";
  };
}

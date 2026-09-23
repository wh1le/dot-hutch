{
  config,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  environment.variables = {
    LLAMA_CACHE = "/var/cache/llama-cpp";
    HF_HOME = "/var/cache/llama-cpp";
  };

  systemd.tmpfiles.rules = [
    "d /var/cache/llama-cpp 0777 root root -"
  ];

  services.llama-cpp = {
    enable = true;
    package =
      if config.networking.hostName == "homepc" then
        pkgs.llama-cpp.override { cudaSupport = true; }
      else
        pkgs.llama-cpp;

    modelsPreset = {
      "qwen3-14b" = {
        hf-repo = "unsloth/Qwen3-14B-GGUF";
        hf-file = "Qwen3-14B-Q4_K_M.gguf";
        alias = "qwen3:14b";
        temp = "0.6";
        top-p = "0.95";
        top-k = "20";
        min-p = "0";
      };

      "mistral-small-3.1" = {
        hf-repo = "bartowski/Mistral-Small-3.1-24B-Instruct-2503-GGUF";
        hf-file = "Mistral-Small-3.1-24B-Instruct-2503-Q4_K_M.gguf";
        alias = "mistral-small3.1";
        temp = "0.15";
      };
    };
  };
}

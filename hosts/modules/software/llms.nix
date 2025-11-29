{ pkgs, unstable, ... }:
{
  services.ollama = {
    enable = true;
    package = unstable.ollama;

    loadModels = [
      # "llama3.2:3b"
      # "phi4-reasoning:14b"
      # "dolphin3:8b"
      # "smallthinker:3b"
      # "gemma3n:e4b"
      # "deepcoder:14b"
      # "qwen3:14b"
      "nomic-embed-text"
      "qwen3-coder:30b"
      # "nomic-embed-text"
    ];
    acceleration = "cuda";
  };

  services.open-webui = {
    enable = true;
    port = 8888;
    host = "127.0.0.1";
  };

  nixpkgs.config.cudaSupport = true;

  # services.caddy.virtualHosts."openwebui.local".extraConfig = ''
  #   reverse_proxy http://192.168.50.1
  # '';

  # networking.hosts."127.0.0.1" = [ "openwebui.local" ];

  environment.systemPackages = [
    pkgs.oterm # TUI chat client for Ollama models.
    # alpaca
    unstable.crush

    pkgs.aichat # All-in-one LLM CLI: shell assistant, REPL/CMD modes, RAG, tools/agents.
    pkgs.fabric-ai # Framework of modular AI prompt workflows and patterns for task automation.

    # aider-chat # Terminal pair-programmer that edits files via an LLM using your VCS context
    pkgs.opencode # Terminal coding agent. Two active repos use the name; both provide a TUI/CLI that runs tasks against your code and GitHub.
    pkgs.codex # openai

    # tgpt # ChatGPT-style CLI for the terminal.
    # smartcat # Unix-style CLI that “puts a brain behind cat,” piping text to an LLM for transformations. Not the Smartcat localization platform.
    # nextjs-ollama-llm-ui # Next.js web UI for local Ollama models; quick chat interface.
    # open-webui # Self-hosted, extensible LLM web interface; connects to Ollama or OpenAI-compatible backends.
  ];
}

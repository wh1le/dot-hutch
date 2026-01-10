{ pkgs, unstable, ... }:

# Models to consider:
# "nomic-embed-text"
# "qwen3-coder:30b"
# "llama3.2:3b"
# "phi4-reasoning:14b"
# "dolphin3:8b"
# "smallthinker:3b"
# "gemma3n:e4b"
# "deepcoder:14b"
# "qwen3:14b"

{
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    loadModels = [
      "qwen3:32b"
      # Uncensored = no content filtering for code generation
      "wizardlm-uncensored:13b"
      # "nous-hermes2-mixtral:8x7b"
    ];

    environmentVariables = {
      CUDA_VISIBLE_DEVICES = "0";
      OLLAMA_NUM_GPU = "1";
    };
  };

  # services.open-webui = {
  #   enable = true;
  #   port = 3003;
  # };

  services.open-webui.enable = false;

  environment.systemPackages = [
    # Comepted to debug build
    # pkgs.oterm # TUI chat client for Ollama models.
    # unstable.crush
    # pkgs.aichat # All-in-one LLM CLI: shell assistant, REPL/CMD modes, RAG, tools/agents.
    # pkgs.fabric-ai # Framework of modular AI prompt workflows and patterns for task automation.
    # pkgs.opencode # Terminal coding agent. Two active repos use the name; both provide a TUI/CLI that runs tasks against your code and GitHub.

    # alpaca
    # aider-chat # Terminal pair-programmer that edits files via an LLM using your VCS context
    # tgpt # ChatGPT-style CLI for the terminal.
    # smartcat # Unix-style CLI that “puts a brain behind cat,” piping text to an LLM for transformations. Not the Smartcat localization platform.
    # nextjs-ollama-llm-ui # Next.js web UI for local Ollama models; quick chat interface.
    # open-webui # Self-hosted, extensible LLM web interface; connects to Ollama or OpenAI-compatible backends.
  ];
}

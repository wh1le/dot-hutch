return	{
  "pablopunk/pi.nvim",
  init = function()
    -- Force notify backend: pi.nvim uses vim.notify (snacks.notifier)
    -- instead of its hardcoded centered status float.
    _G.__pi_force_notify_backend = true
  end,
  keys = {
    { "<leader>lu", ":PiAsk<CR>", mode = "n", desc = "Ask pi" },
    { "<leader>lu", ":PiAskSelection<CR>", mode = "v", desc = "Ask pi (selection)" },
  },
  opts = {
    -- binary = "~/.bin/pi", -- or { "env", "FOO=1", "pi-wrapper" }
    provider = "fireworks",
    model = "accounts/fireworks/models/glm-5p3",
    thinking = "medium",
    tools = { "bash" },
    system_prompt = "You are a helpful assistant.",
    append_system_prompt = "Always respond concisely.",
    context = {
      max_bytes = 24000,
      ask = {
        surrounding_lines = 80,
      },
      selection = {
        surrounding_lines = 40,
      },
      diagnostics = {
        enabled = true,
      },
    },
    skills = true,
    extensions = true,
  },
},


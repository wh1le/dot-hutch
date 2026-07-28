return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",

    -- adapters
    "olimorris/neotest-rspec",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-jest",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        -- require("neotest-plenary"),
        require("neotest.python_adapter"),
        require("neotest-rspec")({
          rspec_cmd = function()
            return vim.tbl_flatten({
              "bundle",
              "exec",
              "rspec",
            })
          end
        }),
        require("neotest-python")({
           dap = { justMyCode = false },
           args = {"-q"}
        }),
        -- require("neotest-jest"),
      },
      summary = {
        enabled = false
      },
      discovery = {
        enabled = false,
        concurrent = 1,
      },
      running = {
        concurrent = true,
      },
    })
  end
}

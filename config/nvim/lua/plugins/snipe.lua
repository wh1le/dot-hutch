return {
  "leath-dub/snipe.nvim",
  keys = {
    {
      "<leader>b",
      function()
        require("snipe").open_buffer_menu()
      end,
      desc = "Open Snipe buffer menu",
    },
  },
  opts = {
    ui = {
      navigate = {
        close_buffer = "d",
      },
      hints = {
        dictionary = "saflewcmpghio",
      },
      max_height = -1,
      open_win_override = {
        relative = "cursor",
        anchor = "SW",
        width = vim.o.columns,                       -- full width
        height = math.min(10, vim.o.lines - 2),      -- tweak if you want taller
        row = vim.o.lines - vim.o.cmdheight,         -- stick to the bottom
        col = 0,
      },
      nav = {
        preview = true,
      },
      buffer_format = { "-> ", "icon", " ", "filename", " ~ ", "directory", function(buf)
          if vim.fn.isdirectory(vim.api.nvim_buf_get_name(buf.id)) == 1 then
            return " ", "SnipeText"
          end
        end 
      },
      -- open_win_override = (function()
      --   local w = 0
      --   local H = vim.api.nvim_win_get_height(w)
      --   local W = 40 --vim.api.nvim_win_get_width(w)
      --   return {
      --     relative = "win",  -- anchor to the current split
      --     win = w,
      --     anchor = "SW",
      --     width = W,                 -- exactly this split’s width
      --     height = math.min(14, H),  -- fit inside the split
      --     row = H,                   -- pin to bottom of split
      --     col = 0,
      --     border = "rounded",
      --   }
      -- end)(),
    },
  },
}

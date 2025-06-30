vim.g.lightline = {
  active = {
    left = {
      { 'mode', 'paste' },
      { 'readonly', 'filename', 'modified' },
    },
    right = {
      { 'lineinfo' },
      { 'percent' },
      { 'fileformat' },
    },
  }
}

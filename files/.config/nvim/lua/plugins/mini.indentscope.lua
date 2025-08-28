return {
  "echasnovski/mini.indentscope",
  version = "*",
  enabled = false,
  config = function()
    require('mini.indentscope').setup({
      symbol = '┃',
      draw = {
        animation = require('mini.indentscope').gen_animation.none(),
      }
    })
  end,
}

-- │ U+2502 BOX DRAWINGS LIGHT VERTICAL
-- ┃ U+2503 BOX DRAWINGS HEAVY VERTICAL
-- ╎ U+254E BOX DRAWINGS LIGHT DOUBLE DASH VERTICAL
-- ║ U+2551 BOX DRAWINGS DOUBLE VERTICAL
-- ┆ U+2506 BOX DRAWINGS TRIPLE DASH VERTICAL
-- ┊ U+250A BOX DRAWINGS QUADRUPLE DASH VERTICAL
-- ❘ U+2758 LIGHT VERTICAL BAR
-- ❙ U+2759 MEDIUM VERTICAL BAR
-- ❚ U+275A HEAVY VERTICAL BAR
-- ∣ U+2223 DIVIDES
-- ǀ U+01C0 LATIN LETTER DENTAL CLICK
-- ¦ U+00A6 BROKEN BAR
-- ⎸ U+23B8 LEFT VERTICAL BOX LINE
-- ⎹ U+23B9 RIGHT VERTICAL BOX LINE
-- ⎪ U+23AA CURLY BRACKET EXTENSION
-- ▏ U+258F LEFT ONE EIGHTH BLOCK
-- ▎ U+258E LEFT ONE QUARTER BLOCK
-- ▍ U+258D LEFT THREE EIGHTHS BLOCK
-- ▌ U+258C LEFT HALF BLOCK
-- ｜ U+FF5C FULLWIDTH VERTICAL LINE (double-width, will shift columns)

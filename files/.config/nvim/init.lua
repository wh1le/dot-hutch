NM = {}

require("helpers.os")
require("helpers.path")
require("helpers.tests")
require("helpers.language_providers")
require("helpers.lazy")
require("helpers.quit")

require("config.system_providers")
require("config.core")
-- require("config.colors")
require("config.bindings")
require("config.callbacks")
require("config.copypaste")
require("config.spell")

NM.lazy.setup()

vim.cmd("filetype plugin indent on")

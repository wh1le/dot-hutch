local start = hs.timer.absoluteTime()
local log = require("log")
local utils = require("utils")

hs.ipc.cliInstall()
hs.ipc.cliSaveHistory(true)
hs.window.animationDuration = 0
hs.application.enableSpotlightForNameSearches(true)

log.i("Resolving app map")
utils.setup()

log.i("Loading modules")
local layout = require("layout")
local lifecycle = require("lifecycle")
local location = require("location")
local mappings = require("mappings")
local screenshot = require("screenshot")
local spoons = require("spoons")
local wifi = require("wifi")
local window = require("window-management")

log.i("Setting up spoons")
spoons.setup()

log.i("Setting up mappings")
mappings.setup()

log.i("Setting up window management")
window.setup()

log.i("Setting up location")
location.setup()

log.i("Starting Wi-Fi watcher")
wifi.start()

log.i("Setting up layout watcher")
layout.setup()

log.i("Setting up lifecycle watcher")
lifecycle.setup()

log.i("Setting up screenshot watcher")
screenshot.setup()

log.i("Starting borders")
hs.execute("pkill -f '/opt/homebrew/bin/borders' 2>/dev/null", true)
hs.task.new("/bin/bash", nil, { os.getenv("HOME") .. "/.config/borders/bordersrc" }):start()

log.i("Starting config watcher")
utils.startConfigWatcher({ hs.configdir })

local elapsed = math.floor((hs.timer.absoluteTime() - start) / 1000000)
hs.alert("Config loaded")
hs.notify.show("Hammerspoon", "", string.format("Initialized in %dms", elapsed))
log.i(string.format("Configuration initialized (%dms)", elapsed))

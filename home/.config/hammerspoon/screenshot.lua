local log = require("log")
local utils = require("utils")

local DEFAULT_DIRECTORY = "~/Pictures/screenshots"
local IMAGE_EXTENSIONS = {
	png = true,
	jpg = true,
	jpeg = true,
	tiff = true,
	pdf = true,
}

local M = {
	watcher = nil,
	pending = {},
}

local function isCapture(path)
	local name = path:match("[^/]+$")
	if not name or name:sub(1, 1) == "." then
		return false
	end

	local extension = (name:match("%.([%a%d]+)$") or ""):lower()
	return IMAGE_EXTENSIONS[extension] == true
end

function M.directory()
	local configured = hs.execute("/usr/bin/defaults read com.apple.screencapture location 2>/dev/null")
	configured = configured and configured:gsub("%s+$", "") or ""
	if configured == "" then
		configured = DEFAULT_DIRECTORY
	end

	return utils.expandPath(configured)
end

function M.copyToClipboard(path)
	local image = hs.image.imageFromPath(path)
	if not image then
		log.wf("Unable to read screenshot '%s'", tostring(path))
		return false
	end

	if not hs.pasteboard.writeObjects(image) then
		log.wf("Unable to copy screenshot '%s' to the clipboard", tostring(path))
		return false
	end

	return true
end

local function handleFiles(files, flagTables)
	for index, path in ipairs(files or {}) do
		local flags = (flagTables or {})[index] or {}
		local created = flags.itemCreated or flags.itemRenamed

		if created and isCapture(path) and not M.pending[path] and utils.pathExists(path) then
			M.pending[path] = true

			utils.debounce("screenshot.copy." .. path, 0.4, function()
				M.pending[path] = nil
				if utils.pathExists(path) and M.copyToClipboard(path) then
					log.df("Copied screenshot to clipboard: %s", path)
				end
			end)
		end
	end
end

function M.capture()
	local dir = M.directory()
	local filename = os.date("Screenshot %Y-%m-%d at %H.%M.%S") .. ".png"
	local path = dir .. "/" .. filename
	os.execute(string.format('/usr/sbin/screencapture -i "%s"', path))
	if utils.pathExists(path) then
		hs.timer.doAfter(0, function()
			M.copyToClipboard(path)
		end)
	end
end

function M.stop()
	if M.watcher then
		M.watcher:stop()
		M.watcher = nil
	end
	M.pending = {}
end

function M.setup(directory)
	M.stop()

	local path = utils.expandPath(directory) or M.directory()
	if not utils.pathExists(path) then
		local ok, err = hs.fs.mkdir(path)
		if not ok then
			log.wf("Unable to create screenshot directory '%s': %s", tostring(path), tostring(err))
			return false
		end
	end

	M.watcher = hs.pathwatcher.new(path, handleFiles)
	M.watcher:start()
	log.df("Watching screenshots in %s", path)

	return true
end

return M

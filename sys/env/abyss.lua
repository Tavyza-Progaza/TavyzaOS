-- Abyss window manager.

gpu = kernel.primary_gpu
local abyss = require("abyss")
local e = require("event")
apps = {}
io.println("LOADING ABYSS...")

io.clear()
local w, h = gpu.getResolution()
gpu.fill(1, 1, w, h, " ")

if fs.exists("/live") then
	abyss.dialogue("Live environment", "It appears you are running TavyzaOS off of an install media.")
end
function within(min, max, x)
	return x > min and x < max
end

function draw_taskbar()
	gpu.set(1, h, "[APPS]")
	gpu.set(7, h, "[SYS]")
	gpu.set(1, 1, "[" .. _G._OSVERSION .. "]")
end

function app_menu()
	for app in fs.list("/sys/apps/") do
		table.insert(apps, app)
	end
	base = (h - 1) - #apps
	for i, app in ipairs(apps) do
		gpu.set(1, base - i, "(" .. app .. ")")
	end
end

local function system()
	settings = { "Shutdown", "Reboot", "Log out" }
	base = (h - 1) - #settings
	for i, setting in ipairs(settings) do
		gpu.set(1, base - i, "(" .. setting .. ")")
	end
end

local function get_input(_, _, tx, ty, button)
	if within(1, 6, tx) and ty == h - 1 then
		app_menu()
	end
	if within(7, 13, tx) and ty == h - 1 then
		system()
	end
end

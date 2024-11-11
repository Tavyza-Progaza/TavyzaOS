-- Abyss window manager.

gpu = kernel.primary_gpu
local abyss = require("abyss")
local e = require("event")
--local util = require("util")

io.println("LOADING ABYSS...")

--util.clear() this aint working hang on
local w, h = gpu.getResolution()
gpu.fill(1, 1, w, h, " ")

if fs.exists("/live") then
	abyss.dialogue("Live environment", "It appears you are running TavyzaOS off of an install media.")
end

function draw_taskbar()
	gpu.set(1, h, "[APPS]")
	gpu.set(7, h, "[SYS]")
	gpu.set(1, 1, "[" .. _G._OSVERSION .. "]")
end

draw_taskbar()

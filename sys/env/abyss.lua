-- Abyss window manager.

gpu = kernel.primary_gpu
local abyss = require("abyss")
local e     = require("event")

io.println("LOADING ABYSS...")

util.clear()
if fs.exists("/live") then
    abyss.dialogue("Live environment", "It appears you are running TavyzaOS off of an install media.")
end
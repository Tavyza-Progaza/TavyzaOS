local term = require("term")
local event = require("event")
local gpu = require("component").gpu
local fs = require("filesystem")

local options = {
  "test option one",
  "test option two",
  "test option three",
  "platano"
}

local config = io.open("/sys/thercon", "r")
local bkclr = config:read("*8")


local selected = 1

local function drawMenu()
  term.clear()

  for i, option in ipairs(options) do
    if i == selected then
      gpu.setForeground(0xFFFFFF)
      gpu.setBackground(0x0000FF)
    else
      gpu.setForeground(0x000000)
  		gpu.setBackground(bkgclr)
    end
      
    term.setCursor(1, i)
    term.write(option)
  end

  gpu.setForeground(0x000000)
  gpu.setBackground(0xFFFFFF)
end

drawMenu()

while true do
  local event = (event.pull())
end
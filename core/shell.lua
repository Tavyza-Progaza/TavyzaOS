-- Gonna make a new shell
shell = {}
io.setGpu(kernel.primary_gpu)
gpu = kernel.primary_gpu
io.println("TavyzaOS shell 0.0.3 for " .. _G._OSVERSION)
io.println("In alpha. Expect issues.")

local function magiclines(s)
	if s:sub(-1) ~= "\n" then
		s = s .. "\n"
	end
	return s:gmatch("(.-)\n")
end

local function write_err(s)
	local fg = gpu.getForeground()
	gpu.setForeground(0xFF0000)
	for s in magiclines(s) do
		io.println(s)
	end
	gpu.setForeground(fg)
end

local function line()
	io.print("\n")
	local fg = gpu.getForeground()
	gpu.setForeground(0x00FF00)
	io.print(_G.WD .. " ~> ")
	gpu.setForeground(fg)
end

local function run_cmd(file)
	local words = {}
	for word in file:gmatch("%S+") do
		table.insert(words, word)
	end
	file = words[1]
	table.remove(words, 1)
	if file == "" then
		write_err("Must specify file name")
		return
	end
	if not fs.exists(_G.WD .. file) or not fs.exists(_G.WD .. file .. ".lua") then -- replace with a global working directory
		file = "/cmd/" .. file
	elseif fs.exists(_G.WD .. file .. ".lua") then
		file = file .. ".lua"
	end
	if fs.exists(file) then
		xpcall(require(file), function(message)
			write_err(message)
			write_err(debug.traceback())
		end, table.unpack(words))
	else
		write_err(file .. " does not exist.")
	end
end

local function start()
	io.clear()
	local buffer = ""
	line()
	while true do
		local key = keyboard.getNextKey()
		if key == "BACK" then
			if buffer ~= "" then
				buffer = buffer.sub(1, -2)
				io.erase(1)
			end
		elseif key == "ENTER" then
			io.println("")
			run_cmd(buffer)
			buffer = ""
			line()
		else
			io.print(key)
			buffer = buffer .. key
		end
	end
end

function shell.getShell()
	return thread.create(start, 8)
end

return shell

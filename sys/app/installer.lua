local component = require("component")
local gpu = component.gpu
local fs = require("filesystem")
local e = require("event")
local t = require("term")
local c = require("computer")
local i = require("internet")

local w, h = gpu.getResolution()
gpu.fill(1, 1, w, h, " ")

local function centerText(y, text, color)
    local x = math.floor(w / 2 - #text / 2)
    gpu.setForeground(color)
    gpu.set(x, y, text)
end

local function installerMenu()
    local options = {"Install TherOS from floppy (DEPRICATED)", "Install/update TherOS from GitHub", "Update Installer from GitHub", "Install a Separate Program from floppy", "Exit Installer"}
    t.clear()
    gpu.fill(1, 1, w, h, " ")
    centerText(1, "TherOS 1.0.2 Installer", 0xFFFFFF)
    for i, option in ipairs(options) do
        centerText(3 + (i - 1) * 2, option, 0xFFFFFF)
    end
end

local function installTherOS()
  print("Welcome to the TherOS installer version 0.2.2. Please wait while the program gathers the system files.")
  local scriptPath = "/mnt/---"
  local scriptId = "---" --modify if this changes to a seperate floppy
  print("drive id is " .. scriptId)
  print("Script path:", scriptPath)
  for entry in fs.list(scriptPath) do
    local source = scriptPath
    local dest = "/home/bin"
    if fs.exists("/home/bin") and fs.isDirectory("/home/bin") then
      print("'bin' directory detected, proceeding...")
    else
      print("'bin' directory not detected, creating...")
      os.execute("mkdir /home/bin")
      print("created 'bin' directory (used for apps)")
    end
    print("copying main menu...")
    os.execute("cp /mnt/" .. scriptId .. "/main.lua  " .. dest)
    print("done")
    print("copying file manager...")
    os.execute("cp /mnt/" .. scriptId .. "/file_manager.lua  " .. dest)
    print("done")
    print("copying program installer...")
    os.execute("cp /mnt/" .. scriptId .. "/program_installer.lua  " .. dest)
    print("done")
    print("copying command prompt...")
    os.execute("cp /mnt/" .. scriptId .. "/command_prompt.lua  " .. dest)
    print("done")
    print("copying file creator...")
    os.execute("cp /mnt/" .. scriptId .. "/create_file.lua  " .. dest)
    print("done")
    print("copying OS installer...")
    os.execute("cp /mnt/" .. scriptId .. "/installer.lua  " .. dest)
    print("done")
    print("copying TherOS text adventure...")
    os.execute("cp /mnt/" .. scriptId .. "/hello.lua  " .. dest)
    print("done")
    print("copying changelog.txt...")
    os.execute("cp /mnt/" .. scriptId .. "/changelog.txt " .. dest)
    print("done")
    print("copying new .shrc...")
    os.execute("cp /mnt/" .. scriptId .. "/.shrc " .. "/home")
    print("done")
  end
    centerText(h - 2, "Installation complete. Ready for reboot.", 0xFFFFFF)
    os.sleep(2)
    os.execute("reboot")
end

local function installFromGithub()
  print("Welcome to the TherOS installer version 1.0.2")
  print("1 - TherOS stable release")
  print("2 - TherOS bleeding edge (may contain bugs!)")
  io.write("-> ")
  ver = io.read()
  print("!! ATTENTION !! BY INSTALLING THEROS, YOU UNDERSTAND THAT THIS SYSTEM WILL NO LONGER OPEN THE SHELL ON BOOT.")
  io.write("Do you want to continue having read the notice above? yes i do / N -> ")
  confirm = io.read()
  if ver == "1" and confirm == "yes i do" then
   print("-- 1/4 CREATING DIRECTORIES --")
    print("checking for /sys/apps")
    if fs.exists("/sys/apps") and fs.isDirectory("/sys/apps") then
      print("/sys/apps exists, skipping...")
    else
      print("/sys/apps does not exist, creating...")
      fs.makeDirectory("/sys/apps")
    end
    print("checking for /sys/util")
    if fs.exists("/sys/util") and fs.isDirectory("/sys/util") then
      print("/sys/util exists, skipping...")
    else
      print("/sys/util does not exist, creating...")
      fs.makeDirectory("/sys/util")
    end
    print("checking for /sys/env")
    if fs.exists("/sys/env") and fs.isDirectory("/sys/env") then
      print("/sys/env exists, skipping...")
    else
      print("/sys/env does not exist, creating...")
      fs.makeDirectory("/sys/env")
    end
    print("-- 2/4 DOWNLOADING LIBRARIES --")
    print("centerText.lua -> /lib/centerText.lua")
    os.execute("wget -f -q https://raw.githubusercontent.com/Tavyza/TherOS/main/lib/centerText.lua /lib/centerText.lua")
    print("filesystem_ext.lua -> /lib/filesystem_ext.lua")
    os.execute("wget -f -q https://raw.githubusercontent.com/Tavyza/TherOS/main/lib/filesystem_ext.lua /lib/filesystem_ext.lua")
    print("-- 3/4 DOWNLOADING SYSTEM --")
    print("main.lua -> /sys/env/main.lua")
    os.execute("wget -f -q https://raw.githubusercontent.com/Tavyza/TherOS/main/sys/env/main.lua /sys/env/main.lua")
    print("file_manager.lua -> /sys/apps/file_manager.lua")
    os.execute("wget -f -q https://raw.githubusercontent.com/Tavyza/TherOS/main/sys/app/file_manager.lua /sys/apps/file_manager.lua")
    print("installer.lua -> /sys/apps/installer.lua")
    os.execute("wget -f -q https://raw.githubusercontent.com/Tavyza/TherOS/main/sys/app/installer.lua /sys/apps/installer.lua")
    print("program_installer.lua -> /sys/apps/program_installer.lua")
    os.execute("wget -f -q https://raw.githubusercontent.com/Tavyza/TherOS/main/sys/app/program_installer.lua /sys/apps/program_installer.lua")
    print("manual.lua -> /sys/apps/manual.lua")
    os.execute("wget -f -q https://raw.githubusercontent.com/Tavyza/TherOS/main/sys/app/manual.lua /sys/apps/manual.lua")
    print("therterm.lua -> /sys/util/therterm.lua")
    os.execute("wget -f -q https://raw.githubusercontent.com/Tavyza/TherOS/main/sys/util/therterm.lua /sys/util/therterm.lua")
    print("changelog.txt -> /sys/changelog.txt")
    os.execute("wget -f -q https://raw.githubusercontent.com/Tavyza/TherOS/main/sys/changelog.txt")
    print("-- 4/4 GRAPPING BOOT --")
    print("removing shell starter...")
    fs.remove("/boot/94_shell.lua")
    print("systempuller.lua -> /boot/94_bootloader.lua")
    os.execute("wget -f -q https://raw.githubusercontent.com/Tavyza/TherOS/main/boot/systempuller.lua /boot/94_bootloader.lua")
    print("Installation finished! A reboot is required to get the system set up. Would you like to reboot now?")
    io.write("y/N -> ")
    rb = io.read()
    if rb == "y" then
      c.shutdown(true)
    else
      os.exit()
    end
  elseif ver == "2" and confirm == "yes i do" then
    print("-- 1/4 CREATING DIRECTORIES --")
    print("checking for /sys/apps")
    if fs.exists("/sys/apps") and fs.isDirectory("/sys/apps") then
      print("/sys/apps exists, skipping...")
    else
      print("/sys/apps does not exist, creating...")
      fs.makeDirectory("/sys/apps")
    end
    print("checking for /sys/util")
    if fs.exists("/sys/util") and fs.isDirectory("/sys/util") then
      print("/sys/util exists, skipping...")
    else
      print("/sys/util does not exist, creating...")
      fs.makeDirectory("/sys/util")
    end
    print("checking for /sys/env")
    if fs.exists("/sys/env") and fs.isDirectory("/sys/env") then
      print("/sys/env exists, skipping...")
    else
      print("/sys/env does not exist, creating...")
      fs.makeDirectory("/sys/env")
    end
    print("Creating reload file (KEEP EMPTY, THIS IS JUST TO RELOAD THE MAIN ENVIRONMENT)")
    os.execute("touch /sys/apps/reload.lua")
    print("-- 2/4 DOWNLOADING LIBRARIES --")
    print("centerText.lua -> /lib/centerText.lua")
    os.execute("wget -f https://raw.githubusercontent.com/Tavyza/TherOS/bleeding-edge/lib/centerText.lua /lib/centerText.lua")
    print("filesystem_ext.lua -> /lib/filesystem_ext.lua")
    os.execute("wget -f -q https://raw.githubusercontent.com/Tavyza/TherOS/main/lib/filesystem_ext.lua /lib/filesystem_ext.lua")
    print("-- 3/4 DOWNLOADING SYSTEM --")
    print("main.lua -> /sys/env/main.lua")
    os.execute("wget -f https://raw.githubusercontent.com/Tavyza/TherOS/bleeding-edge/sys/env/main.lua /sys/env/main.lua")
    print("file_manager.lua -> /sys/apps/file_manager.lua")
    os.execute("wget -f https://raw.githubusercontent.com/Tavyza/TherOS/bleeding-edge/sys/app/file_manager.lua /sys/apps/file_manager.lua")
    print("installer.lua -> /sys/apps/installer.lua")
    os.execute("wget -f https://raw.githubusercontent.com/Tavyza/TherOS/bleeding-edge/sys/app/installer.lua /sys/apps/installer.lua")
    print("program_installer.lua -> /sys/apps/program_installer.lua")
    os.execute("wget -f https://raw.githubusercontent.com/Tavyza/TherOS/bleeding-edge/sys/app/program_installer.lua /sys/apps/program_installer.lua")
    print("therterm.lua -> /sys/util/therterm.lua")
    os.execute("wget -f https://raw.githubusercontent.com/Tavyza/TherOS/bleeding-edge/sys/util/therterm.lua /sys/util/therterm.lua")
    print("-- 4/4 GRAPPING BOOT --")
    print("removing shell starter...")
    fs.remove("/boot/94_shell.lua")
    print("systempuller.lua -> /boot/94_systempuller.lua")
    os.execute("wget https://raw.githubusercontent.com/Tavyza/TherOS/bleeding-edge/boot/systempuller.lua /boot/94_systempuller.lua")
    print("Installation finished! A reboot is required to get the system set up. Would you like to reboot now?")
    io.write("y/N -> ")
    rb = io.read()
    if rb == "y" then
      c.shutdown(true)
    else
      os.exit()
    end
  end
end

local function updateInstaller()
    print("Pulling new installer and overwriting...")
    os.execute("wget -f https://raw.githubusercontent.com/Tavyza/TherOS/main/sys/app/installer.lua /sys/apps/installer.lua")
    print("Finished. Exiting...")
    os.exit()
end

local function installSeparateProgram()
  print("Please type the drive ID. you can find this by leaving the screen, hovering over the drive, and looking at the first 3 characters of the long string in the tooltip of the drive (the thing with the name and stuff)")
  io.write("drive ID -> ")
  local installMedia = io.read()
  print ("Getting files...")
  local sourcedir = "/mnt/" .. installMedia
  local destdir = "/home/"
  -- Iterate through all files in the source directory
  for entry in fs.list(sourcedir) do
    local sourcePath = sourcedir .. "/" .. entry
    local destinationPath = destdir .. "/" .. entry
    if not fs.isDirectory(sourcePath) then
      fs.copy(sourcePath, destinationPath)
    end
  end
end
  centerText(h - 2, "Files copied successfully.", 0xFFFFFF)


installerMenu()

while true do
    local _, _, _, y, _, _ = e.pull("touch")
    local choice = math.floor((y - 3) / 2) + 1
    if choice == 1 then
        installTherOS()
    elseif choice == 2 then
        installFromGithub()
    elseif choice == 3 then
        updateInstaller()
    elseif choice == 4 then
        installSeparateProgram()
    elseif choice == 5 then
        break
    end
    installerMenu()
end

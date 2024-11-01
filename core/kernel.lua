local a=..._G._OSVERSION="TavyzaOS 0.0.2 Open Alpha"_G.runlevel=1;_G.kernel={}function kernel.runlevel()return _G.runlevel end;local b=computer.shutdown;computer.shutdown=function(c)_G.runlevel=c and 6 or 0;if os.sleep then computer.pushSignal("SIGTERM")os.sleep(0.2)computer.pushSignal("SIGKILL")os.sleep(0.2)end;b(c)end;kernel.panic=function(d)if os.log then os.log("KERNEL PANIC: "..d)end;computer.pushSignal("SIGKILL")local e=component.list("gpu",true)()if e then e=component.proxy(e)local f,g=e.getResolution()e.setForeground(0xFFFFFF)e.setBackground(0xFF0000)e.set(1,g,"KERNEL PANIC: "..d)end;_G.runlevel=0;error(d)end;kernel.message=function(h)h="KERNEL: "..h;if os.log then os.log(h)end;local e=component.list("gpu",true)()if e then e=component.proxy(e)local f,g=e.getResolution()e.setForeground(0x000000)e.setBackground(0xFFA500)e.fill(1,g,f,g," ")e.set(1,g,h)end end;local f,g;local i=component.list("screen",true)()local e=i and component.list("gpu",true)()if e then e=component.proxy(e)if not e.getScreen()then e.bind(i)end;kernel.primary_gpu=e;f,g=e.maxResolution()e.setResolution(f,g)e.setBackground(0x000000)e.fill(1,1,f,g," ")end;local j=1;local function k(h)if os.log then os.log(h)end;if e then if runlevel==1 then e.setForeground(0xAB0202)end;if runlevel==2 then e.setForeground(0xFFA500)end;if runlevel==3 then e.setForeground(0xE3CC20)end;if runlevel==4 then e.setForeground(0x02AD10)end;e.set(1,j,"["..computer.uptime().."] "..h)if j==g then e.copy(1,2,f,g,0,-1)e.fill(1,g,f,g," ")else j=j+1 end end end;k("Initializing ".._OSVERSION)local function l(m)k("Loading "..m)local n,d=a(m)if n then local o=table.pack(pcall(n))if o[1]then return table.unpack(o,2,o.n)else kernel.panic(o[2])end else kernel.panic(d)end end;l("/core/os.lua")_G.fs=l("/core/fs.lua")k("Mounting filesystem")fs.mount(computer.getBootAddress(),"/")fs.remove("/log.txt")_G.runlevel=2;k("Seeding random")math.randomseed(os.time())l("/core/interrupt.lua")kernel.scheduler=l("/core/scheduler.lua")_G.thread=l("/core/thread.lua")_G.io=l("/core/io.lua")_G.runlevel=3;_G.keyboard=l("/core/keyboard.lua")kernel.scheduler.addThread(keyboard.getDownListenerThread())kernel.scheduler.addThread(keyboard.getUpListenerThread())_G.shell=l("/core/shell.lua")_G.runlevel=4;_G.require=l("/core/require.lua")k("Finishing library initialization")computer.pushSignal("SIGINIT")io.setGpu(kernel.primary_gpu)_G.runlevel=5;if e then e.setForeground(0xFFFFFF)end;if fs.exists("/autorun.lua")then local p=thread.create(require("/autorun.lua"),6)kernel.baseThread=p;kernel.scheduler.addThread(p)else local p=shell.getShell()kernel.baseThread=p;kernel.scheduler.addThread(p)end
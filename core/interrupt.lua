local function a()local b=nil;while true do ev,_,_,b=computer.pullSignal(0)if ev=="key_down"then break end end;return keyboard.keysReverse[b]end;function kernel.doInterrupt()local c=kernel.primary_gpu;local d,e=c.getResolution()local f=c.getForeground()local g=c.getBackground()local h={}for i=1,e+1 do h[i]=c.get(i,e)end;if keyboard==nil then kernel.message("Keyboard not loaded - exiting")return end;kernel.message("Awaiting input")local b=a()if b=="p"then kernel.message("Scheduler guarantees priority "..tostring(kernel.scheduler.guarantee))elseif b=="t"then kernel.message("Running "..tostring(#kernel.scheduler.threads).." threads")elseif b=="c"then kernel.baseThread.co=nil;local j=false;for k,l in ipairs(kernel.scheduler.threads)do if l.id==kernel.baseThread.id then table.remove(kernel.scheduler.threads,k)kernel.message("Killed thread "..kernel.baseThread.id)j=true;break end end;if not j then kernel.message("Could not kill thread (already dead?)")end;local l=shell.getShell()kernel.baseThread=l;kernel.scheduler.addThread(l)elseif b=="r"then kernel.baseThread:restart()kernel.message("Restarted thread "..kernel.baseThread.id)end;a()c.setForeground(f)c.setBackground(g)c.fill(1,e,d,e," ")for i=1,e+1 do c.set(i,e,h[i])end end
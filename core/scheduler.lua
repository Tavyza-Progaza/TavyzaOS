local a={}a.guarantee=10;a.threads={}a.callbacks={}local b=a.threads;function a.addThread(c)table.insert(b,c)end;local function d(e)a.current_thread=e;local f,g=e:run()a.current_thread=nil;return f,g end;local function h(i,j)if i.waiting then return false end;if i.sleep==j.sleep then return i.priority<j.priority end;return i.sleep<j.sleep end;local function k(e,l)if a.callbacks[l]==nil then a.callbacks[l]={}end;table.insert(a.callbacks[l],e)end;local function m(n)if a.callbacks[n[1]]==nil then return end;for o,e in ipairs(a.callbacks[n[1]])do e.event=n end;local p=a.callbacks[n[1]]a.callbacks[n[1]]={}for o,e in ipairs(p)do local f,g=d(e)if f then if g~=nil then k(e,g)end end end end;function a.begin()local q=computer.uptime()local r=false;while kernel.runlevel()==5 do local s={}for t,e in ipairs(b)do if e.waiting then goto u end;if e.priority>a.guarantee then local v=e.priority-a.guarantee;if e.grief>=v then grief=grief-v;if grief<0 then grief=0 end else grief=grief+2;goto u end end;do local f,g=d(e)if f then if g~=nil then k(e,g)end else if not e:isAlive()then os.log("Thread "..e.id.." died: "..tostring(g))table.insert(s,t)end end end::u::local n={computer.pullSignal(0)}if n~=nil and n[1]~=nil then m(n)end end;for o,t in ipairs(s)do table.remove(b,t)end;local w=computer.uptime()local x=w-q;for o,e in ipairs(b)do e.sleep=e.sleep-x;if e.sleep<0 then e.sleep=0 end end;q=w;if x>0.15 then if not r then if a.guarantee>1 then a.guarantee=a.guarantee-1;os.log("Set scheduler guarantee to "..a.guarantee)end end end;table.sort(b,h)if keyboard~=nil then if keyboard.isCtrlDown()and keyboard.isKeyDown(keyboard.keys.k)then kernel.doInterrupt()keyboard.reset()r=true end end;if#b==0 then kernel.panic("All threads have died!")end end end;return a
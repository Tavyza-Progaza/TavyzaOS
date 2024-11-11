local a={}local b={name="",children={},links={}}local c={}local function d(e)local f={}for g in e:gmatch("[^\\/]+")do local h,i=g:find("^%.?%.$")if h then if i==2 then table.remove(f)end else table.insert(f,g)end end;return f end;local function j(e,k,l)checkArg(1,e,"string")local m={}local f=d(e)local n={}local o=b;local p=1;while p<=#f do local g=f[p]n[p]=o;if not o.children[g]then local q=o.links[g]if q then if not l and#f==p then break end;if m[e]then return nil,string.format("link cycle detected '%s'",e)end;m[e]=p;local r="/"..table.concat(f,"/",p+1)local s;if q:match("^[^/]")then s=table.concat(f,"/",1,p-1).."/"local t=d(q)local u=d(s..q)local v=p-1+#t-#u;p=p-v;o=n[p]else s=""p=1;o=b end;e=s..q..r;f=d(e)g=nil elseif k then o.children[g]={name=g,parent=o,children={},links={}}else break end end;if g then o=o.children[g]p=p+1 end end;local w,x=o,#f>=p and table.concat(f,"/",p)local y=x;while o and not o.fs do y=y and a.concat(o.name,y)or o.name;o=o.parent end;return o,y,w,x end;function a.canonical(e)local z=table.concat(d(e),"/")return z end;function a.concat(...)local A=table.pack(...)for p,B in ipairs(A)do checkArg(p,B,"string")end;return a.canonical(table.concat(A,"/"))end;function a.get(e)local o=j(e)if o.fs then local C=o.fs;e=""while o and o.parent do e=a.concat(o.name,e)o=o.parent end;e=a.canonical(e)if e~="/"then e="/"..e end;return C,e end;return nil,"no such file system"end;function a.realPath(e)checkArg(1,e,"string")local o,y=j(e,false,true)if not o then return nil,y end;local f={y or nil}repeat table.insert(f,1,o.name)o=o.parent until not o;return table.concat(f,"/")end;function a.mount(D,e)checkArg(1,D,"string","table")if type(D)=="string"then D=a.proxy(D)end;assert(type(D)=="table","bad argument #1 (file system proxy or address expected)")checkArg(2,e,"string")local E;if not b.fs then if e=="/"then E=e else return nil,"rootfs must be mounted first"end else local F;E,F=a.realPath(e)if not E then return nil,F end;if a.exists(E)and not a.isDirectory(E)then return nil,"mount point is not a directory"end end;local G;if c[E]then return nil,"another filesystem is already mounted here"end;for H,o in pairs(c)do if o.fs.address==D.address then G=o;break end end;if not G then G=select(3,j(E,true))D.fsnode=G else local I=a.path(E)local J=select(3,j(I,true))local K=a.name(E)G=setmetatable({name=K,parent=J},{__index=G})J.children[K]=G end;G.fs=D;c[E]=G;return true end;function a.path(e)local f=d(e)local z=table.concat(f,"/",1,#f-1).."/"return z end;function a.name(e)checkArg(1,e,"string")local f=d(e)return f[#f]end;function a.proxy(L,M)checkArg(1,L,"string")if not component.list("filesystem")[L]or next(M or{})then return a.internal.proxy(L,M)end;return component.proxy(L)end;function a.exists(e)if not a.realPath(a.path(e))then return false end;local o,y,w,x=j(e)if not x or w.links[x]then return true elseif o and o.fs then return o.fs.exists(y)end;return false end;function a.isDirectory(e)local E,N=a.realPath(e)if not E then return nil,N end;local o,y,w,x=j(E)if not w.fs and not x then return true end;if o.fs then return not y or o.fs.isDirectory(y)end;return false end;function a.list(e)local o,y,w,x=j(e,false,true)local z={}if o then z=o.fs and o.fs.list(y or"")or{}if not x then for O,P in pairs(w.children)do if not P.fs or c[a.concat(e,O)]then table.insert(z,O.."/")end end;for O in pairs(w.links)do table.insert(z,O)end end end;local A={}for H,K in ipairs(z)do A[a.canonical(K)]=K end;return function()local Q,B=next(A)A[Q or false]=nil;return B end end;function a.open(e,R)checkArg(1,e,"string")R=tostring(R or"r")checkArg(2,R,"string")assert(({r=true,rb=true,w=true,wb=true,a=true,ab=true})[R],"bad argument #2 (r[b], w[b] or a[b] expected, got "..R..")")local o,y=j(e,false,true)if not o then return nil,y end;if not o.fs or not y or({r=true,rb=true})[R]and not o.fs.exists(y)then return nil,"file not found"end;local S,N=o.fs.open(y,R)if not S then return nil,N end;return setmetatable({fs=o.fs,handle=S},{__index=function(T,Q)if not T.fs[Q]then return end;if not T.handle then return nil,"file is closed"end;return function(self,...)local U=self.handle;if Q=="close"then self.handle=nil end;return self.fs[Q](U,...)end end})end;a.findNode=j;a.segments=d;a.fstab=c;function a.makeDirectory(e)if a.exists(e)then return nil,"file or directory with that name already exists"end;local o,y=a.findNode(e)if o.fs and y then local V,N=o.fs.makeDirectory(y)if not V and not N and o.fs.isReadOnly()then N="filesystem is readonly"end;return V,N end;if o.fs then return nil,"virtual directory with that name already exists"end;return nil,"cannot create a directory in a virtual directory"end;function a.lastModified(e)local o,y,w,x=a.findNode(e,false,true)if not o or not w.fs and not x then return 0 end;if o.fs and y then return o.fs.lastModified(y)end;return 0 end;function a.mounts()local W={}for e,o in pairs(a.fstab)do table.insert(W,{o.fs,e})end;return function()local next=table.remove(W)if next then return table.unpack(next)end end end;function a.link(X,Y)checkArg(1,X,"string")checkArg(2,Y,"string")if a.exists(Y)then return nil,"file already exists"end;local Z=a.path(Y)if not a.exists(Z)then return nil,"no such directory"end;local _,N=a.realPath(Z)if not _ then return nil,N end;if not a.isDirectory(_)then return nil,"not a directory"end;local H,H,w,H=a.findNode(_,true)w.links[a.name(Y)]=X;return true end;function a.umount(a0)checkArg(1,a0,"string","table")local E;local D;local a1;if type(a0)=="string"then E=a.realPath(a0)a1=a0 else D=a0 end;local a2={}for e,o in pairs(a.fstab)do if E==e or a1==o.fs.address or D==o.fs then table.insert(a2,e)end end;for H,e in ipairs(a2)do local o=a.fstab[e]a.fstab[e]=nil;o.fs=nil;o.parent.children[o.name]=nil end;return#a2>0 end;function a.size(e)local o,y,w,x=a.findNode(e,false,true)if not o or not w.fs and(not x or w.links[x])then return 0 end;if o.fs and y then return o.fs.size(y)end;return 0 end;function a.isLink(e)local K=a.name(e)local o,y,w,x=a.findNode(a.path(e),false,true)if not o then return nil,y end;local X=w.links[K]if not x and X~=nil then return true,X end;return false end;function a.copy(a3,a4)local a5=false;local a6,N=a.open(a3,"rb")if a6 then local a7=a.open(a4,"wb")if a7 then repeat a5,N=a6:read(1024)if not a5 then break end;a5,N=a7:write(a5)if not a5 then a5,N=false,"failed to write"end until not a5;a7:close()end;a6:close()end;return a5==nil,N end;local function a8(C)checkArg(1,C,"table")if C.isReadOnly()then return C end;local function a9()return nil,"filesystem is readonly"end;return setmetatable({rename=a9,open=function(e,R)checkArg(1,e,"string")checkArg(2,R,"string")if R:match("[wa]")then return a9()end;return C.open(e,R)end,isReadOnly=function()return true end,write=a9,setLabel=a9,makeDirectory=a9,remove=a9},{__index=C})end;local function aa(e)local E,N=a.realPath(e)if not E then return nil,N end;if not a.isDirectory(E)then return nil,"must bind to a directory"end;local ab,ac=a.get(E)if E==ac then return ab end;local y=E:sub(#ac+1)local function ad(ae)return function(af,...)return ae(a.concat(y,af),...)end end;local ag={type="filesystem_bind",address=E,isReadOnly=ab.isReadOnly,list=ad(ab.list),isDirectory=ad(ab.isDirectory),size=ad(ab.size),lastModified=ad(ab.lastModified),exists=ad(ab.exists),open=ad(ab.open),remove=ad(ab.remove),read=ab.read,write=ab.write,close=ab.close,getLabel=function()return""end,setLabel=function()return nil,"cannot set the label of a bind point"end}return ag end;a.internal={}function a.internal.proxy(L,M)checkArg(1,L,"string")checkArg(2,M,"table","nil")M=M or{}local ah,C,N;if M.bind then C,N=aa(L)else for ai in component.list("filesystem",true)do if component.invoke(ai,"getLabel")==L then ah=ai;break end;if ai:sub(1,L:len())==L then ah=ai;break end end;if not ah then return nil,"no such file system"end;C,N=component.proxy(ah)end;if not C then return C,N end;if M.readonly then C=a8(C)end;return C end;function a.remove(e)local function aj()local H,H,w,x=a.findNode(a.path(e),false,true)if not x then local K=a.name(e)if w.children[K]or w.links[K]then w.children[K]=nil;w.links[K]=nil;while w and w.parent and not w.fs and not next(w.children)and not next(w.links)do w.parent.children[w.name]=nil;w=w.parent end;return true end end;return false end;local function ak()local o,y=a.findNode(e)if o.fs and y then return o.fs.remove(y)end;return false end;local V=aj()V=ak()or V;if V then return true else return nil,"no such file or directory"end end;function a.rename(al,am)if a.isLink(al)then local H,H,w,H=a.findNode(a.path(al))local X=w.links[a.name(al)]local z,N=a.link(X,am)if z then a.remove(al)end;return z,N else local an,ao=a.findNode(al)local ap,aq=a.findNode(am)if an.fs and ao and ap.fs and aq then if an.fs.address==ap.fs.address then return an.fs.rename(ao,aq)else local z,N=a.copy(al,am)if z then return a.remove(al)else return nil,N end end end;return nil,"trying to read from or write to virtual directory"end end;return a
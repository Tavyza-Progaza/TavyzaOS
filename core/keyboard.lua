local a={}a.keys={}a.keysReverse={}a.keysDown={}function a.isKeyDown(b)return a.keysDown[b]==true end;function a.isShiftDown()return a.isKeyDown(a.keys.lshift)or a.isKeyDown(a.keys.rshift)end;function a.isCtrlDown()return a.isKeyDown(a.keys.lcontrol)or a.isKeyDown(a.keys.rcontrol)end;local function c(d)local e=tonumber(d)if e==nil then return string.upper(d)else local f={")","!","@","#","$","%","^","&","*","("}return f[e+1]end end;function a.getNextKey()while true do local g,g,g,g,h=thread.wait("key_down")if h~=nil then local d=a.keysReverse[h]if d~=nil then return a.isShiftDown()and c(d)or d end end end end;function a.reset()a.keysDown={}end;function a.handleKeystroke(g,i,g,j,h)if h~=nil then a.keysDown[h]=i=="key_down"end end;function a.getDownListenerThread()return thread.create(function()while true do a.handleKeystroke(thread.wait("key_down"))end end,1)end;function a.getUpListenerThread()return thread.create(function()while true do a.handleKeystroke(thread.wait("key_up"))end end,1)end;a.keysReverse[0x02]="1"a.keysReverse[0x03]="2"a.keysReverse[0x04]="3"a.keysReverse[0x05]="4"a.keysReverse[0x06]="5"a.keysReverse[0x07]="6"a.keysReverse[0x08]="7"a.keysReverse[0x09]="8"a.keysReverse[0x0A]="9"a.keysReverse[0x0B]="0"a.keysReverse[0x1E]="a"a.keysReverse[0x30]="b"a.keysReverse[0x2E]="c"a.keysReverse[0x20]="d"a.keysReverse[0x12]="e"a.keysReverse[0x21]="f"a.keysReverse[0x22]="g"a.keysReverse[0x23]="h"a.keysReverse[0x17]="i"a.keysReverse[0x24]="j"a.keysReverse[0x25]="k"a.keysReverse[0x26]="l"a.keysReverse[0x32]="m"a.keysReverse[0x31]="n"a.keysReverse[0x18]="o"a.keysReverse[0x19]="p"a.keysReverse[0x10]="q"a.keysReverse[0x13]="r"a.keysReverse[0x1F]="s"a.keysReverse[0x14]="t"a.keysReverse[0x16]="u"a.keysReverse[0x2F]="v"a.keysReverse[0x11]="w"a.keysReverse[0x2D]="x"a.keysReverse[0x15]="y"a.keysReverse[0x2C]="z"a.keysReverse[0x39]=" "a.keysReverse[0x34]="."a.keysReverse[0x33]=","a.keysReverse[0x28]="'"a.keysReverse[0x35]="/"a.keysReverse[0x0E]="BACK"a.keysReverse[0x1C]="ENTER"a.keys["1"]=0x02;a.keys["2"]=0x03;a.keys["3"]=0x04;a.keys["4"]=0x05;a.keys["5"]=0x06;a.keys["6"]=0x07;a.keys["7"]=0x08;a.keys["8"]=0x09;a.keys["9"]=0x0A;a.keys["0"]=0x0B;a.keys.a=0x1E;a.keys.b=0x30;a.keys.c=0x2E;a.keys.d=0x20;a.keys.e=0x12;a.keys.f=0x21;a.keys.g=0x22;a.keys.h=0x23;a.keys.i=0x17;a.keys.j=0x24;a.keys.k=0x25;a.keys.l=0x26;a.keys.m=0x32;a.keys.n=0x31;a.keys.o=0x18;a.keys.p=0x19;a.keys.q=0x10;a.keys.r=0x13;a.keys.s=0x1F;a.keys.t=0x14;a.keys.u=0x16;a.keys.v=0x2F;a.keys.w=0x11;a.keys.x=0x2D;a.keys.y=0x15;a.keys.z=0x2C;a.keys.apostrophe=0x28;a.keys.at=0x91;a.keys.back=0x0E;a.keys.backslash=0x2B;a.keys.capital=0x3A;a.keys.colon=0x92;a.keys.comma=0x33;a.keys.enter=0x1C;a.keys.equals=0x0D;a.keys.grave=0x29;a.keys.lbracket=0x1A;a.keys.lcontrol=0x1D;a.keys.lmenu=0x38;a.keys.lshift=0x2A;a.keys.minus=0x0C;a.keys.numlock=0x45;a.keys.pause=0xC5;a.keys.period=0x34;a.keys.rbracket=0x1B;a.keys.rcontrol=0x9D;a.keys.rmenu=0xB8;a.keys.rshift=0x36;a.keys.scroll=0x46;a.keys.semicolon=0x27;a.keys.slash=0x35;a.keys.space=0x39;a.keys.stop=0x95;a.keys.tab=0x0F;a.keys.underline=0x93;a.keys.up=0xC8;a.keys.down=0xD0;a.keys.left=0xCB;a.keys.right=0xCD;a.keys.home=0xC7;a.keys["end"]=0xCF;a.keys.pageUp=0xC9;a.keys.pageDown=0xD1;a.keys.insert=0xD2;a.keys.delete=0xD3;return a
local a=function(b)local c=""local d=fs.open(b)if d==nil then return nil end;while true do local e=d:read(math.maxinteger)if e==nil then break end;c=c..e end;d:close()return load(c,"="..b,"bt",_G)end;return a
-- abyss window manager lib
-- TODO: Make a proper window manager library
gpu = kernel.primary_gpu
e = require(event)

abyss = {}

function abyss.makewin(x, y, w, h, title)
    gpu.fill(x,y,w,1,"═") -- top
    gpu.fill(x,y+h-1,w,h,"═") -- bottom
    gpu.fill(x,y,1,h,"║") -- left
    gpu.fill(x+w-1,1,w,h,"║") -- right
    gpu.set(x,y,"╔") -- top left corner
    gpu.set(x+w-1,y,"╗") -- top right corner
    gpu.set(x,y+h-1,"╚") -- bottom left corner
    gpu.set(x+w-1,y+h-1,"╝") -- bottom right corner
    gpu.set((w/2)-(#title/2), y, "["..title.."]")
    gpu.set(x+1, y, "[#]")
    gpu.set(w-1, y, "[X]")
    return {x, y, w, h, title}
end
function abyss.dialogue(title, content, options)
    abyss.makewin((w/2)-(#content/2), (h/2)-2, (w/2)+(#content/2), (h/2)+2, title)
    if #options > 3 then
        -- handle that
    end
    for _, option in ipairs(options do)
        if #options == 1 then
            gpu.set((w/2)-(#option/2), (h/2)+1)
        end
    end
end

return abyss

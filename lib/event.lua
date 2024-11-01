-- making an event lib to wrap around the computer signal functions

event = {}
-- copying these 2 near verbatum
function event.register(key, callback, interval, times, opt_handlers)
    local handler = {key = key, times = times or 1, callback = callback, interval = interval or math.huge,}
    handler.timeout = computer.uptime() + handler.interval
    opt_handlers = opt_handlers or handlers
    local id = 0
    repeat
        id = id + 1
    until not opt_handlers[id]
    opt_handlers[id] = handler
    return id
end

function event.listen(name, callback)
    checkArg(1, name, "string")
    checkArg(2, callback, "function")
    for _, handler in pairs(handlers) do
        if handler.key == name and handler.callback == callback then
            return false
        end
    end
    return event.register(name, callback, math.huge, math.huge)
end

function event.ignore(name, callback)
    checkArg(1, name, "string")
    checkArg(2, callback, "function")
    for id, handler in pairs(event.handlers) do
        if handler.key == name and handler.callback == callback then
            event.handlers[id] = nil
            return true
        end
    end
    return false
end

return event
local search  = function (k,superClasses)
    for i = 1, #superClasses do
        local class = superClasses[i]
        if class[k] then
            return class[k]
        end
    end
end

function createClass(...)
    local superClasses = {...}
    local c = {}

    setmetatable(c,{__index = function (t,k)
        return search(k,superClasses)
    end})

    c.__index = c

    function c:new(o)
        o = o or {}
        setmetatable(o,c)
        return o
    end

    return c
end
Vector2 = {x=0,y=0}

function Vector2:new(x,y)
    local x = x or 0
    local y = y or 0
    local t = {x=x,y=y}
    setmetatable(t,{__index = self})
end
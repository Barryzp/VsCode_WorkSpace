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

    -- 通过闭包的方式把多个父类保存起来，然后通过__index元方法来访问
    setmetatable(c,{__index = function (t,k)
        return search(k,superClasses)
    end})

    c.__index = c

    -- 给与子类的构造方法
    function c:new(o)
        o = o or {}
        setmetatable(o,c)
        return o
    end

    return c
end

local name = {
    info = "Barry",
    setname = function(self,name)
        self.info = name
    end,
    getname = function(self)
        return self.info
    end,
}

local age = {
    number = 0,
    setage = function(self,age)
        self.number = age
    end,
    getage = function(self)
        return self.number
    end,
}

local barry = createClass(name,age)
barry:setage(23)
barry:setname("Barry")
print(barry:getname(),barry:getage())

local barrySon = barry:new()
print(barrySon:getname(),barrySon:getage())
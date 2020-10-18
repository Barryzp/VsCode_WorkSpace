--[[
    用于验证元表的self是不是同一份，是同一份！
    只是说没有给某些值赋值时，它会自动去元表找
]]

require("module.utils.log")
BaseClass = {
    clsName = "BaseClass"
}

function BaseClass:print()
    log.print(self.clsName)
end

function BaseClass:new(class)
    local cls = class or {}
    setmetatable(cls,{__index = self})

    -- ts paragragh -- setmetatable(cls,{__newindex = function (arg1, arg2, arg3)
    --     print(arg1)
    -- end})
    return cls
end

local barry = {}
barry = BaseClass:new(barry)
barry.clsName = "Barry"

local david = BaseClass:new()
david:print()
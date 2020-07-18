local newmetatable = {}

local base = {
    age = 12,
    __index = function (t,k,v)
        print("access a attri dont exist.")
        print(k,v)
    end,
    __newindex = newmetatable
}

local sub = {
    name = "尼玛"
}

setmetatable(sub,base)
sub.desc = "this is a desc about self table."
print(sub.age)
print(sub.desc)
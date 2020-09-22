local Quene = require "Quene"
local a={
    name="ClassA"
}
setmetatable(a,{__index = Quene})

a:unshift(10)
a:unshift(1)
a:unshift(5)

print(a:peek())

local c ={
    myAttri = "Attri1"
}
c.__index = Quene
print(c:getCount())
print(c.myAttri)
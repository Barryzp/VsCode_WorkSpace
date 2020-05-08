--[[mytable={"hello","My","name","is","Barry"}

newtable={}
mymetatable={
__newindex=newtable

--]]

--[[
function(tab,key,value)
print("我们要修改的key为："..key.."\n修改之后的值为："..value)
rawset(tab,key,value)
end
mytable=setmetatable(mytable,mymetatable)

mytable[6]="hey"
print(mytable[6])
print(newtable[6])
--]]

--[[
--__add方法的使用
mytable={"hello","My","name","is","Barry"}
mymetatable={
__add=function(tab,newtab)
local maxIndex=0
for k,v in pairs(tab) do
maxIndex=k
end

for k,v in pairs(newtab) do
maxIndex=maxIndex+1
table.insert(tab,maxIndex,v)
end
--记得要返回
return tab
end
}

mytable=setmetatable(mytable,mymetatable)
newtable={"just","fortest"}
v2=newtable+mytable--OK
mytable=mytable+newtab--Fine,too

for k,v in pairs(v2) do
print(k,v)
end
--]]

mytable={"hello","My","name","is","Barry"}
mymetatable={
__call=function(tab,arg1,arg2,arg3)
if tab~=nil then
print(tab[1])
end
--arg1会默认赋值成那个tab，神奇地一批
print(arg1[1],arg2,arg3)
return "lol"
end,

__tostring=function(tab)
str=''
for k,v in pairs(tab) do
str=str..v..','
end
return str
end
}
mytable=setmetatable(mytable,mymetatable)

newtable={"hello"}
print(mytable(newtable,10,20))
print(mytable)

--object=table+function
--对于一个对象，它是既有属性也有方法的，这一点表可以做到
Person={
name="barry",
age=22,
}
function Person:eat()
print("此时一名名叫"..self.name.."的男子正在吃饭.")
end

--采用元表的方式来实现创建新对象
function Person:new(o)
--返回为真的那一个
--t一定要设置为局部变量！
local t=o or {}
setmetatable(t,{__index=self})
--[[
或者是这样写
setmetatable(t,self)
self.__index=self
--]]

return t
end
--:运算符是用来解决如果我们有了一个新的对象a，那么就需要改变表中带有表名的所有内容，有了:，我们就可以直接通过self来访问表里的内容了
Person:eat()

--可以通过这种方式添加新属性
p1=Person:new({weight=30})
--对元表是不会产生影响的
p1.name="zhang"

--通过这种方式实现继承
Student=Person:new({grade=1})
stu1=Student:new()
stu1.name="小明"
print(stu1.grade)
stu1:eat()
print(p1:eat())
print(p1.weight)

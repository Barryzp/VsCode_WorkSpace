module={}

module.var1='a string'
module.fun1=function()
print('it\'s a function in module.')
end

--相当于一个私有的
local function fun2()
print("local function can be called in local.")
end

function fun3()
fun2()
print("global function only you required this module.")
end

return module

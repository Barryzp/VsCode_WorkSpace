--[[
--Method1：
--定义协同函数create方法
co=coroutine.create(
function(a,b)
print(a+b)
--暂停一下协程
coroutine.yield()
print(a-b)
end
)
--]]
--[[
--只有调用了resume协同函数才会启动,第一个参数是哪个协同函数，之后的参数传到协同函数中的参数
coroutine.resume(co,10,20)
print("lollll________lol.")
--使暂停的协程继续执行，后面两个参数其实可以省略掉，因为前面会把参数保存
coroutine.resume(co)

--]]

--[[
--Method2：
co=coroutine.wrap(
function(a,b)
print(a+b)
end
)
co(10,20)
--]]

--[[
--定义协同函数create方法
co=coroutine.create(
function(a,b)
print(a+b)
print(coroutine.status(co))
--暂停一下协程,yield中有多少个参数都会被传递出来，会被当成返回值
coroutine.yield(a/b)
print(a-b)
--在暂停之后的resume函数中才会返回
return a*b
end
)

print(coroutine.status(co))
--resume的返回值有多个，第一个是是否启动成功，后面的参数就是里面的返回值
print(coroutine.resume(co,10,20))
print(coroutine.resume(co,10,20))
print(coroutine.status(co))
--]]

--第二个resume的参数是第一个yield的返回值。
co=coroutine.create(function()
local r= coroutine.yield("inside coroutine.")
print("hold___on")
print("value of r is "..r)
coroutine.yield("second inside coroutine.")
end)

print(coroutine.resume(co))
print(coroutine.resume(co,"send arg to local r."))

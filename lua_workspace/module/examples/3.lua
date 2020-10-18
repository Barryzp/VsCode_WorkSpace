local str="{200,100,200}@,,,,"
local idx=string.find(str,".")
print(idx)

local rd = math.random(1,1)
print(rd)

local array={1,2,2,3,2}
local counter=0

Person = {}

print("Counter:",counter)

local aFun = function (callback)
    print("aFun called.")
    callback()
end

aFun(function ()
    print("this is a callback.",array[2])
end)


-- use generetor使用真正的迭代器：“生成器”
local realItr = function (t,actf)
    
end

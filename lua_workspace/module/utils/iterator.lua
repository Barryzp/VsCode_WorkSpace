local value = function (t)
    local i = 0
    return function ()
        i = i+1
        return t[i]
    end
end

local t = {10,20,30}
local iter = value(t)

while true do
    local v = iter()
    if nil == v then
        break
    end

    print(v)
end

for v in value(t) do
    print(v)
end

local t = {
    name = 4,
    age = 12,
    weight = 56
}

for key, value in next,t do
    print(key,value)
end

print("=======================================Divide Line=======================================")

for key, value in pairs(t) do
    print(key,value)
end

print("=======================================Divide Line=======================================")

for value in pairs(t) do
    print(value)
end

print("=======================================Divide Line=======================================")
-- 根据键值对表排序的迭代器
local pairsByKey = function (t)
    local a= {}
    for n in pairs(t) do
        a[#a+1]=n
    end

    table.sort(a)
    local i = 0
    return function ()
        i=i+1
        return a[i],t[a[i]]
    end
end

for val in pairsByKey(t) do
    print(val)
end
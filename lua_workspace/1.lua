function Insert(str, idx, insertStr)
    local strLen=#str
    if idx>strLen then
        print("WARN: idx is above of length of mainStr")
        idx=strLen
    end

    local id=idx
    local preSubStr=string.sub(str,1,id)
    local backSubStr=string.sub(str,id,strLen)
    return preSubStr..insertStr..backSubStr
end

local str="barry."
print(Insert(str,1,"my name is "))

local str2 = "我吃大西瓜"

print(#str2)


local t={}

function unshift(value)
    table.insert(t,#t+1,value)
end

function shift()
    return table.remove(t,1)
end


unshift(1)
unshift(2)
unshift(3)

local removeItem=shift()
print("******************remove",removeItem)

for key, value in pairs(t) do
    print(key,value)
end

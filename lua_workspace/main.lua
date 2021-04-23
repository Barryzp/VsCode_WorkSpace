require("module.utils.arrayEx")
require("module.utils.log")
StringEx = {}
-- 字符串分割，可以和array.join一起来用，使用方法同js
StringEx.split = function (str,seperator)
    local arr = {}
    while true do
        local startIdx,endIdx = string.find(str,seperator)
        if startIdx == nil then
            table.insert(arr,str)
            break
        else
            local strLen = #str
            local preStr = string.sub(str,1,startIdx - 1)
            local backStr = string.sub(str,endIdx + 1,strLen)
            str = backStr
            table.insert(arr,preStr)
        end
    end

    return arr
end

local fun = function()
    return 1, 2
end

local fun2 = function()
    return fun()
end

LOG(fun2())

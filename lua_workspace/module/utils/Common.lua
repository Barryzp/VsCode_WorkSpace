Common = {}

Common.split = function (str,seperator)
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
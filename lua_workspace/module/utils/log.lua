log = {}

log.printArr = function (tab)
    print('{')
    for i = 1, #tab do
        print(string.format("   [%d] = %d",i,tab[i]))
    end
    print('}')
end

log.printTab = function (tab,tuckunder)
    tuckunder = tuckunder or 1
    local tuckunderStr = ''
    for i = 1, tuckunder do
        tuckunderStr = tuckunderStr.."  "
    end

    print(tuckunderStr..'{')
    for key, value in pairs(tab) do
        if type(value) == "table" then
            log.printTab(value,tuckunder+1)
        else
            local val = tostring(value)
            print(string.format("   %s[%s] = %s",tuckunderStr,key,val)) 
        end
    end
    print(tuckunderStr..'}')
end

LOG = function (...)
    local args = {...}
    local type = type(args[1])
    if type == "table" then
        log.printTab(args[1])
    else
        print(...)
    end
end

array = {}
function array.filterEx(tab, func)
    local t = {}
    local counter = 1

    for i = 1, #tab do
        if func(tab[i], i) then
            t[counter] = tab[i]
            counter = counter +1
        end
    end

	return t
end

function array.filter(tab, func)
    for i = 1, #tab do
        if func(tab[i], i) then
            return tab[i]
        end
    end

	return nil
end

function array.contain(t,ele)
    for i = 1, #t do
        if t[i] == ele then
            return true
        end
    end

    return false
end

function array.shuffle (array)
    local len = #array
    math.randomseed(os.time())
    for i = 1, len do
        local rl = len-i+1
        local idx = math.ceil(math.random() * rl)
        array[rl],array[idx] = array[idx],array[rl]
    end
end

local t = {
    50,60,80,90,100
}

local temp = array.filterEx(t,function (item)
    if item>60 then
        return true
    else
        return false
    end
end)

for i = 1, #temp do
    print(temp[i])
end

print("isContain 80?",array.contain(t,1))


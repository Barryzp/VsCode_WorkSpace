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

function array.reverse(tab)
    if array.isEmpty(tab) then
        return
    end

    local len = #tab
    local mod = len % 2
    local endId = math.floor(len / 2)
    for i = 1, endId do
        local item = tab[i]
        local swapId = len - i + 1
        local backItem = tab[swapId]
        tab[i],tab[swapId] = backItem,item
    end

    return tab
end

function array.isEmpty(tab)
    if tab == nil then
        return true
    end
    return next(tab) == nil
end

function array.indexOf(tab,ele)
    for i = 1, #tab do
        if ele == tab[i] then
            return i
        end
    end

    return -1
end

function array.dedup(arr)
    local tempArr = {}
    for i = 1, #arr do
        if indexOf(arr,arr[i]) == i then
            table.insert(tempArr,arr[i])
        end
    end

    return tempArr
end

function array.pop(tab)
    return table.remove(tab,#tab)
end

function array.push(tab,ele)
    table.insert(tab,ele)
end

function array.shift(tab)
    return table.remove(tab,1)
end

function array.unshift(tab,ele)
    return table.insert(tab,1,ele)
end

function array.ranGet(array)
    local len = #array
    local idx = math.ceil(math.random() * len)
    return array[idx]
end

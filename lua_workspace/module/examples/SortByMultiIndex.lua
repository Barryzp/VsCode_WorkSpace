--多关键字排序示例
--解锁>id(从小到大)>等级(从小到大)>是否开放

local ele1={
    id = 1,
    isLock = true,
    lv = 40,
    isOpen = false,
}

local ele2={
    id = 2,
    isLock = false,
    lv = 15,
    isOpen = true,
}

local ele3={
    id = 3,
    isLock = false,
    lv = 40,
    isOpen = true,
}

local ele4={
    id = 4,
    isLock = true,
    lv = 25,
    isOpen = true,
}

local ele5={
    id = 5,
    isLock = false,
    lv = 80,
    isOpen = true,
}

local ele6={
    id = 6,
    isLock = false,
    lv = 60,
    isOpen = true,
}

-- 要把状态映射成值
local statusSort = {
    UNLOCK = 1,
    LOCK = 2,
    UNOPEN = 3
}

--解锁>id(从小到大)>等级(从小到大)>是否开放
--多关键字排序的逻辑就是把关键字转换成状态值，排前面的状态小于排后面的状态这样就使得其排序是在前面的
local array = {ele1,ele2,ele3,ele4,ele5,ele6}
for i = 1, #array do
    local ele = array[i]
    if false == ele.isLock then
        ele.status = statusSort.UNLOCK
    else
        if false == ele.isOpen then
            ele.status = statusSort.UNOPEN
        else
            ele.status = statusSort.LOCK
        end
    end
end

table.sort(array,function (x,y)
    if x.status == y.status then
        return x.id < y.id
    else
        return x.status < y.status
    end
end)

for i = 1, #array do
    local item = array[i]
    print(item.id)
end


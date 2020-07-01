--多关键字排序示例
--解锁>id(从小到大)>等级(从小到大)>是否开放

local ele1={
    id = 1,
    isLock = true,
    lv = 40,
    isOpen = true,
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
    isOpen = false,
}

local ele6={
    id = 6,
    isLock = false,
    lv = 60,
    isOpen = true,
}

-- 要把状态映射成值
local statusSort = {

}

--解锁>id(从小到大)>等级(从小到大)>是否开放，脑子没转过来。。。
local array = {ele1,ele2,ele3,ele4,ele5,ele6}
table.sort(array,function (x,y)
    return x.id<y.id
end)

for i = 1, #array do
    local item = array[i]
    print(item.id)
end


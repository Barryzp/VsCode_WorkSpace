--[[
    Description:useful quene.
    Author:Barry.zp
]]

Quene ={
    datas = {},
    count=0
}

function Quene:shift()
    if 0 == self.count then
        return nil
    end

    self.count = self.count - 1
    return table.remove(self.datas,1)
end

function Quene:unshift(item)
    if nil == item then
        return
    end

    table.insert(self.datas,item)
    self.count = self.count + 1
end

function Quene:peek()
    if 0 == self.count then
        return nil
    end

    return self.datas[1]
end

function Quene:getCount()
    return self.count
end

function Quene:new(table)
    table = table or {}
    setmetatable(table,{__index=self})
    return table
end

return Quene
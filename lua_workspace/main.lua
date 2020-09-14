local LOG = require("log")

local reverse = function (tab)
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

local tab = {
    name = "barry",
    age = 28,
    wife = {
        name = "alice",
        age = 24
    }
}

LOG.printTab(tab)

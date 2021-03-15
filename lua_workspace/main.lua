require("module.utils.arrayEx")
require("module.utils.log")

local t1 = {1, 3, 5, 6, 7, 3, 8}
local t2 = {1, 4, 5, 6}

LOG(array.deduct(t1, t2))
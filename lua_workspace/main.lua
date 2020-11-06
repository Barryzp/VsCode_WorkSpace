require("module.utils.log")
require("module.utils.arrayEx")

local a = {}
a.foo = function (self)
    LOG(self)
end

a:foo()
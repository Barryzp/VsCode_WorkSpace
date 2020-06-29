--模块实际上也就是导出的一个表
print("----------------------module----------------------");
module={};

local function moduleFun( )
    print("一个模块内的local函数被调用.")
end

function module.printSth(  )
    -- body
    moduleFun();
    print("模块表内的方法被调用.")
end

return module;
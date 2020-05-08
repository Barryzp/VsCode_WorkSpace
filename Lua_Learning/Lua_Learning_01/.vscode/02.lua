require "module"

module.fun1();

--altaernative argument function
   --[[ function alternativeFun(...)
        local arg={...}
        for k,v in pairs(arg) do
        print(k..' '..v)
        end
    end
    alternativeFun(1,2,3,4,10)
    str="A string"
    str2=string.upper(str)
    print(str2 )

    array={}
    for i=-2,2 do
    array[i]=i*2
    end

    for i=-2,2 do
        print(array[i])
        end

    douArray={}
    for i=1,3 do
    douArray[i]={}
    for j=1,3 do
    douArray[i][j]=i*j
    end
    end

    for i=1,3 do
    for j=1,3 do
    print(douArray[i][j])
    end
    end

    function squareIterator(state,control)
    if(control>state) then
        return nil
    else
        control=control+1
        return control,control^2
    end
    end
    for k,v in squareIterator,9,1 do
        print(k,v)
    end
    --]]
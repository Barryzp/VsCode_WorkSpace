print("----------------------运算符divide----------------------");
local var1=false;
local var2=20;

if(var1 and var2) then
    print("those value are not nil.")
else
    print("some value wrong.")
end

local aStr='I\'m a string.';
local replaceStr=string.gsub( aStr,"string",'guy');
print(replaceStr);

local findIdx=string.find( replaceStr,'guy' );
print('find index: '..findIdx);


print("----------------------数组divide----------------------");
local array={'I\'m',' a ',' array'};
print('Length of array: '..#array);

local aObject={
    var=29
};
local aTemper=aObject;
aObject.var=90;
aObject.print=function ( )
    print("a internal function for testing oop.")
end

aTemper.print();
print("is same as valueType: "..aTemper.var);

aObject.print();

print("----------------------迭代器divide----------------------");

print("----------------------无状态的迭代器----------------------");
function fiveTimesOfNumbers( maxCount,crtIdx )
    if(crtIdx>=maxCount)
    then return nil;
    else
        crtIdx=1+crtIdx;
        return crtIdx,crtIdx*5;
    end
end

for i,v in fiveTimesOfNumbers,5,0 do
    print(i,v)
end
print("----------------------有状态的迭代器----------------------");

local aTable={"hello","table","godSake"};
function iteratorWithStatus( c )
    local index=0;
    local count=#c;

    --利用闭包的方法来保存状态常量和控制变量
    return function( )
        index=index+1;
        if(index<=count) then
            return c[index];
        end
    end
end

for element in iteratorWithStatus(aTable) do
    print(element)
end

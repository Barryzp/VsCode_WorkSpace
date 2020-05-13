--05_06  -  05_07
print("this is a word from barry.");
local aTable={"sds","wer"};

local aFun=function( )
    -- body
    print("just test.")
end

for k,v in pairs(aTable) do
    print(k.."..."..v);
end

aFun();

for i=10,1,-1 do
    repeat
        if i==6 then
            print("continue code here.")
            break
        end
        print(i,"Loop here.")
    until true
end

--05_08
--循环结构
local counter=0;
while counter<10 do
    print(counter);
    counter=counter+1;
end
print(counter);

print("----------------------for数值循环divide----------------------")

local index = 0;
local index2 = 1
for index=1,10,1 do
    index=9;
    index2=90;
    print(index);
end
print("index = "..index);
print('index2 = '..index2);

print("----------------------for泛型循环divide----------------------")
local table2={"hello","world","I'm","start","happy."};
print("ipairs:");
for i,v in ipairs(table2) do
    print(i,v)
end
print("pairs:");
for k,v in pairs(table2) do
    print(k,v)
end

print("----------------------repeat循环divide----------------------")
local repeatTimes=0;
repeat 
    print(repeatTimes);
    repeatTimes=repeatTimes+1;
until(repeatTimes>10)
print('out of loops area repeatTimes = '..repeatTimes);

print("----------------------if流程控制divide----------------------")
local var1 = 1;
if(var1==1) then
    print("var1 == 1")
else
    print("var1!=1")
end

local var2=28;
if(var2<10) then
    print("var2<10");
elseif(var2<20) then
    print('var2<20')
else
    print('var2>=20')
end

print("----------------------函数可变参数divide----------------------")
local varParamFun=function(...)
    local args={...};
    print('可变参数的长度: '..#args)
    print('select("#",...) = '..select('#', ...));
    for i,v in ipairs(args) do
        print(i,v)
    end

    local len=select('#', ...);
    for i=1,len do
        local temp=select(i,...);
        print(temp);
    end
end

varParamFun(1,nil,2,3);
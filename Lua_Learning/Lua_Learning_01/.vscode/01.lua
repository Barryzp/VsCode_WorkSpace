
--[[可以打分号也可以不打
table1={key1="hello.",key2="world"}
print(table1.key1)
if a==nil then
    print("a==nil")
else
    print("a!=nil")
end

string1='as'..'be'
print(#string1)

table3={key1='hello',key2='world',key3='fucking',key4='asshole'}
for key,val in pairs(table3) do
print(table3[key])
end

function Multiply( n )
    if n==1 then
        return n;
    else 
        return n*Multiply(n-1);
    end
end

print(Multiply(9))

function UseFun(tab,fun)
for k,v in pairs(tab) do
fun(k,v)
end
end

tab4={'nothing','talked'}

function simple ( k,v )
    print(k..' '..v)
end

UseFun(tab4,simple)
--匿名函数
UseFun(tab4,function ( k,v )
    print(k..':'..v)
end)
--]]
var1,var2,var3=45,'num',78
print(var1,var2,var3)

--[[
i=0;
while(i<10) do
i=i+1
print(i)
end
--]]
--[[for temp=1,10,2 do
    print(temp)
end--]]
tab1={key1="hello",key2="world"}
for k,v in pairs(tab1) do
    print(k..' '..v)
end

b=30
if(b<=10) then
print('b小于等于10')
elseif(b<=20) then
    print('b小于等于20大于10')
else 
    print('b>20')
end

local function max(num1,num2)
    if(num1>num2) then
        return num1
        else
            return num2
        end
end

myPrint=function(param)
print('this is my print fun '..param)
end

myPrint(max(20,10))

function manyReturnsFun()
    return 10,20,30,40
end

res1,res2,res3,res4=manyReturnsFun()
print(res1,res2,res3,res4)

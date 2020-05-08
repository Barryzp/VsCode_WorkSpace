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
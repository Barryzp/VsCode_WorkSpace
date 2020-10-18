local str = "ax1,,,ax2,,"
local itr = string.gmatch(str,",")

for key, value in itr do
    print(key,value)
end
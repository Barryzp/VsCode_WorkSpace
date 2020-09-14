local resStr = "我得名字10叫做黑原物，{0,2,10}啦啦{0,2,4}啦啦。"
local resStr = string.gsub(resStr,'{(%d+),(%d+),(%d+)}','')
print(resStr)
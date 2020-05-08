--[[
--以只读方式打开文件
--file=io.open("file1.txt","r")
--如果是以w方式写入会把源文件清空
file=io.open("file1.txt","a")
io.output(file)
--仅仅写入一行
io.write("\nthis is new line.")
--打开文件之后记得关闭
io.close(file)
--]]

--完全模式下的打开和关闭就需要:访问符
file=io.open("file1.txt","r")
print(file:read())
file:close()

file=io.open("file1.txt","a")
file:write("\nthis is a new line by complete type.")
file:close()

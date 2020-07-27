local ostime = os.time()
print(ostime)

-- !*t表示的是UTC时间
local t = os.date("*t",ostime)
print(t.hour)


local time = os.time({
    year = 2020,
    month = 7,
    day = 27,
    hour = 20,
    min = 5
})

local array = {1,2,3,4,6}
table.insert(array,1,10)


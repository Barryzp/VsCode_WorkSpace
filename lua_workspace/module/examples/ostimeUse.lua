local ostime = os.time()
print(ostime)

-- !*t表示的是UTC时间(也就是去掉时区的时间)
local t = os.date("*t",ostime)
print(t.hour)


local getTimeZone = function ()
    local now = os.time()
    return math.floor(os.difftime(now, os.time(os.date("!*t", now)))/3600)
end

local time = os.time({
    year = 2020,
    month = 7,
    day = 27,
    hour = 20,
    min = 5
})

local array = {1,2,3,4,6}
table.insert(array,1,10)


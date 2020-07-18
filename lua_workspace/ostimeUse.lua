local ostime = os.time()
print(ostime)
local t = os.date("*t",ostime)
print(t.hour)

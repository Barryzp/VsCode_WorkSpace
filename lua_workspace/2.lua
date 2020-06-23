local SORT_FLAG={
    Lord = 1,
    ViceLord = 2,
    Flower=3,
    Ladder=4,
    GodTower=5,
    PetFight=6
}
local SORT_FLAG_REV_T={}
for key, value in pairs(SORT_FLAG) do
    SORT_FLAG_REV_T[value]=key
end

local playerTitle={
    "PetFight",
    "ViceLord",
    "Lord",
    "GodTower",
    "Ladder"
}

local sortFun=function (arg1, arg2)
    if SORT_FLAG[arg1] < SORT_FLAG[arg2] then
        return true
    else
        return false
    end
end

table.sort(playerTitle,sortFun)

for key, value in pairs(playerTitle) do
    print(key)
    print(value)
end

local letter_i="i"
local letter_l="l"
local letter_1="1"

local matchStr="I'm your111 deariii fatherl1a."
local shortLetterCount=0
for i = 1, #matchStr do
    local char=string.sub(matchStr,i,i)
    if char == letter_i or 
    char == letter_l or
    char == letter_1 then
        shortLetterCount=shortLetterCount+1
    end
end

print(shortLetterCount)
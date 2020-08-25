function computeRdValue(values,probablities)
    local allProb = 0
    local probLen = #probablities
    for i = 1, probLen do
       local prob = probablities[i]
       allProb = allProb + prob
    end

    math.randomseed(os.time())
    local rdNum = math.random(0,allProb)
    print("random: "..rdNum)
    local lastProb = 0
    local idx = nil
    for i = 1, probLen do
        local itemProb = probablities[i] + lastProb
        if rdNum <= itemProb then
            idx = i
            break
        end
        lastProb = itemProb
    end

    return values[idx]
end

print(computeRdValue({20,100,45},{100,200,100}))
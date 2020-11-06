SimpleFsm = class("SimpleFsm")
propertyReadOnly(SimpleFsm, "tCurState")
propertyReadOnly(SimpleFsm, "tStateMap")
function SimpleFsm:ctor()
    self.tStateMap = {}
    self.tCurState = nil
end
function SimpleFsm:update(dt)
    if self.tCurState then self.tCurState:onUpdate(dt) end
end
function SimpleFsm:register(state)
    self.tStateMap[state:getTag()] = state
end
function SimpleFsm:unregister(state)
    self.tStateMap[state:getTag()] = nil
end
function SimpleFsm:getState(tag)
    return self.tStateMap[tag]
end
function SimpleFsm:transfer(tag, ...)
    local pre = self.tCurState
    local cur = self.tStateMap[tag]
    if pre then pre:onExit() end
    self.tCurState = cur
    cur:onEnter(...)
end
return SimpleFsm
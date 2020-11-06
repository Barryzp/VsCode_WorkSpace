IState = class("IState")
property(IState, "eTag")
function IState:ctor(tag)
    self.eTag = tag
end
--------------start override----------
function IState:onLoad(...) end
function IState:onEnter(...) end
function IState:onUpdate(dt) end
function IState:onExit() end
function IState:onUnload() end
-------------end override-----------
return IState
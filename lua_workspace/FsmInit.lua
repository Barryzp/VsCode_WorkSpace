function UiCycleView:update(deltaTime)
    if self.state == EnumCycleState.None then
        return
    elseif self.state == EnumCycleState.RestraintRolling then
        return
    elseif self.state == EnumCycleState.AutoRolling then
        self:updateAutoRollState(deltaTime)
    elseif self.state == EnumCycleState.NoRolling then
        self:updateNotRollState(deltaTime)
    elseif self.state == EnumCycleState.Touching then
        -- 交由自己触摸函数处理
        return
    elseif self.state == EnumCycleState.ResettingView then
        self:updateResetState(deltaTime)
    end
end

function UiCycleView:transitionReset()
    if self.state == EnumCycleState.RestraintRolling then
        return
    end

    local closeView = self:getCloserItem()
    local posX = closeView.pLayer:gposx()
    local dist = cc.pMul(cc.p(posX,0),-1)
    self.resetSpeed = cc.pMul(dist,1/self.config.resetInterval)
    self.state = EnumCycleState.ResettingView
    self.timeCounter = 0
end

function UiCycleView:transitionRestraintRoll()
    self.state = EnumCycleState.RestraintRolling
end

function UiCycleView:transitionAutoRoll()
    if self.state == EnumCycleState.RestraintRolling then
        return
    end

    self.state = EnumCycleState.AutoRolling
    self.timeCounter = 0
end

function UiCycleView:transitionNotRoll()
    if self.state == EnumCycleState.RestraintRolling then
        return
    end

    self.state = EnumCycleState.NoRolling
    self.timeCounter = 0
    -- 修正偏移值
    self:correctToRightPos()
end

function UiCycleView:transitionTouching()
    if self.state == EnumCycleState.RestraintRolling then
        return
    end

    self.state = EnumCycleState.Touching
end

function UiCycleView:updateResetState(deltaTime)
    self.timeCounter = self.timeCounter + deltaTime
    if self.timeCounter >= math.abs(self.config.resetInterval) then
        -- 暂停一段时间
        self:transitionNotRoll()
        return
    end

    -- 滚动~
    local moveDelta = cc.pMul(self.resetSpeed,deltaTime)
    self:moveAllItems(moveDelta)
end

function UiCycleView:updateAutoRollState(deltaTime)
    self.timeCounter = self.timeCounter + deltaTime
    if self.timeCounter >= self.config.moveDura then
        -- 暂停一段时间
        self:transitionNotRoll()
        return
    end

    -- 滚动~
    local moveDelta = cc.pMul(self.speed,deltaTime)
    self:moveAllItems(moveDelta)
end

function UiCycleView:updateNotRollState(deltaTime)
    self.timeCounter = self.timeCounter + deltaTime
    if self.timeCounter >= self.config.stayDura then
        self:transitionAutoRoll()
    end
end
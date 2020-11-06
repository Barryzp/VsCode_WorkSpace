UiCycleView = class("UiCycleView",XViewBase)

local EnumDirection = {
    None = 0,
    -- 水平
    Horizontal = 1,
    -- 竖直
    Vertical = 2
}

-- 若干种状态（采用的较为简易的状态机处理）
local EnumCycleState = {
    -- 啥都没有，为初始化状态
    None = 0,
    -- 自动滚动
    AutoRolling = 1,
    -- 不滚动
    NoRolling = 4,
    -- 触摸状态
    Touching = 2,
    -- 重置视图中
    ResettingView = 3,
    -- 限制移动
    RestraintRolling = 5
}

local EnumClickEvent = {
    Start = "start",
    End = "end"
}

local CycleViewState = class("CycleViewState",IState)
function CycleViewState.init(self,view)
    self.view = view
    self.timeCounter = 0
end


local IdleState = class("IdleState",CycleViewState)


local AutoRollState = class("AutoRollState",CycleViewState)
function AutoRollState:onEnter()
    self.timeCounter = 0
end

function AutoRollState:onUpdate(dt)
    self.timeCounter = self.timeCounter + dt
    if self.timeCounter >= self.view.config.moveDura then
        self.view.fsm:transfer(EnumCycleState.NoRolling)
        return
    end

    -- 滚动~
    local moveDelta = cc.pMul(self.view.speed,dt)
    self.view:moveAllItems(moveDelta)
end


local NoRollState = class("NoRollState",CycleViewState)
function NoRollState:onEnter()
    self.timeCounter = 0
    self.view:correctToRightPos()
end

function NoRollState:onUpdate(dt)
    self.timeCounter = self.timeCounter + dt
    if self.timeCounter >= self.view.config.stayDura then
        self.view.fsm:transfer(EnumCycleState.AutoRolling)
    end
end


local TouchingState = class("TouchingState",IdleState)


local ResetingState = class("ResetingState",CycleViewState)
function ResetingState:onEnter()
    local closeView = self.view:getCloserItem()
    local posX = closeView.pLayer:gposx()
    local dist = cc.pMul(cc.p(posX,0),-1)
    self.resetSpeed = cc.pMul(dist,1/self.view.config.resetInterval)
    self.timeCounter = 0
end
function ResetingState:onUpdate(dt)
    self.timeCounter = self.timeCounter + dt
    if self.timeCounter >= self.view.config.resetInterval then
        -- 暂停一段时间
        self.view.fsm:transfer(EnumCycleState.NoRolling)
        return
    end

    -- 滚动~
    local moveDelta = cc.pMul(self.resetSpeed,dt)
    self.view:moveAllItems(moveDelta)
end


local RestraintState = class("RestraintState",IdleState)


function UiCycleView:ctor()
    XViewBase.ctor(self)

    self:resetData()
end

function UiCycleView:resetData()
    self.parentNode = nil
    self.touchLayer = nil

    self.itemSize = cc.size(0,0)
    self.touchRect = cc.rect(0,0,0,0)

    self.beginPos = cc.p(0,0)
    self.touchDelta = cc.p(0,0)

    self.timeCounter = 0
    self.speed = cc.p(0,0)
    self.resetSpeed = cc.p(0,0)

    self.firstIdx = 0
    self.lastIdx = 0
    self.itemViewList = {}
    self.config = {}

    local allState = {
        [EnumCycleState.None] = IdleState,
        [EnumCycleState.AutoRolling] = AutoRollState,
        [EnumCycleState.NoRolling] = NoRollState,
        [EnumCycleState.Touching] = TouchingState,
        [EnumCycleState.ResettingView] = ResetingState,
        [EnumCycleState.RestraintRolling] = RestraintState
    }

    self.fsm = SimpleFsm.new()
    for tag,state in pairs(allState) do
        local tempState = state.new(tag)
        tempState:init(self)
        self.fsm:register(tempState)
    end

    self.fsm:transfer(EnumCycleState.None)
end

function UiCycleView:init(...)
    XViewBase.init(self,...)

    self.LayerTouch:setClippingEnabled(true)
end

--[[
    desc: 锚点为(0,0)
    config = {
        itemViewName,   -- 单个item的viewname
        itemDatas,      -- item数据
        showNum,        -- item的显示个数?
        stayDura,       -- 停留时间
        speed,          -- 多长时间(秒为单位)滑动一个单位(一个item)
        resetInterval   -- 重置时间(默认为0.1)
    }
]]

function UiCycleView:testDatas()
    local datas = {}
    for i = 1, 5 do
        local r = math.random(0,255)
        local g = math.random(0,255)
        local b = math.random(0,255)
        local data = {
            info = "攀哥"..i,
            color = cc.c3b(r,g,b)
        }

        table.insert(datas,data)
    end

    return datas
end

function UiCycleView:getDataByIdx(idx)
    local datas = self.config.itemDatas
    return datas[idx % (self.config.itemNum + 1)]
end

function UiCycleView:setListView(config)
    local datas = self:testDatas()
    config.itemDatas = datas
    config.itemNum = #config.itemDatas
    self.config = config
    self.config.moveDura = math.abs(self.config.speed)
    self.config.resetInterval = self.config.resetInterval or 0.1
    self:spawnItems()
    self:setInfo()
    self:correctItemPos()

    self:initTouchListener()
    self.fsm:transfer(EnumCycleState.NoRolling)
end

-- 生成item?
function UiCycleView:spawnItems()
    local config = self.config
    local showNum = config.showNum
    if #config.itemDatas == 1 then
        -- 不准动
        self.fsm:transfer(EnumCycleState.RestraintRolling)
    end

    -- 可以顺便优化一下，只需要生成显示数量+1
    for i = 1, showNum + 1 do
        local view = XAddView(config.itemViewName,self,"LayerContent")
        view:setInfo(self:getDataByIdx(i))
        table.insert(self.itemViewList,view)
        self:addItemClickHandler(view)
    end

    self.firstIdx = 1
    self.lastIdx = showNum + 1
end

function UiCycleView:addIndex(index)
    local dataLen = #self.config.itemDatas
    if index >= dataLen then
        index = 0
    end

    return index + 1
end

function UiCycleView:subIndex(index)
    local dataLen = #self.config.itemDatas
    if index <= 1 then
        index = dataLen + 1
    end

    return index - 1
end

-- 把第一个元素放到最后一个位置
function UiCycleView:put1stItem2Last(lastPos)
    -- 这两个B是同时跟着加同时跟着减的
    self.lastIdx = self:addIndex(self.lastIdx)
    self.firstIdx = self:addIndex(self.firstIdx)
    local first = array.shift(self.itemViewList)
    array.push(self.itemViewList,first)
    first.pLayer:pos(lastPos)
    first:setInfo(self:getDataByIdx(self.lastIdx))
end

-- 把最后一个元素放到第一个位置
function UiCycleView:putLastItemTo1st(firstPos)
    self.firstIdx = self:subIndex(self.firstIdx)
    self.lastIdx = self:subIndex(self.lastIdx)
    local last = array.pop(self.itemViewList)
    array.unshift(self.itemViewList,last)
    last.pLayer:pos(firstPos)
    last:setInfo(self:getDataByIdx(self.firstIdx))
end

-- 初始化触摸区域
function UiCycleView:setInfo()
    local config = self.config
    local itemSize = self.itemViewList[1].LayerTouch:getContentSize()
    self.itemSize = itemSize
    local touchWidth = config.showNum * itemSize.width
    -- 暂时不管竖直方向
    local touchHeight = itemSize.height
    local wp = Common.getWPos(self.LayerContent)
    self.touchRect = cc.rect(wp.x,wp.y,touchWidth,touchHeight)
    self.LayerContent:setContentSize(cc.size(touchWidth,touchHeight))
    self.LayerTopTouch:setContentSize(cc.size(touchWidth,touchHeight))

    self.speed = cc.p(itemSize.width / config.speed,0)
end

-- 排好位置
function UiCycleView:correctItemPos()
    local itemCount = #self.itemViewList
    local curX = 0
    local curY = 0
    for i = 1,itemCount do
        local item = self.itemViewList[i]
        item.pLayer:pos(curX,curY)
        curX = curX + self.itemSize.width
    end
end

-- 是否在区域内
function UiCycleView:isInRect(p)
    return cc.rectContainsPoint(self.touchRect,p)
end

-- 整体移动delta
function UiCycleView:moveAllItems(delta)
    local dist = cc.pGetLength(delta)
    if dist == 0 then
        return
    end

    -- 把delta转化下
    delta = cc.p(delta.x,0)
    local itemCount = #self.itemViewList
    for i = 1, itemCount do
        local item = self.itemViewList[i]
        local curP = item.pLayer:gpos()
        local moveDestP = cc.pAdd(curP,delta)
        item.pLayer:pos(moveDestP)
    end

    self:restraintItems()
end

function UiCycleView:getCloserItem()
    -- 找到最近的那个
    local miniDist = 9999
    local idx = 1
    for i = 1, #self.itemViewList do
        local item = self.itemViewList[i]
        local itemX = math.abs(item.pLayer:gposx())
        if miniDist >= itemX then
            miniDist = itemX
            idx = i
        end
    end

    return self.itemViewList[idx],idx
end

function UiCycleView:correctToRightPos()
    -- 应该采用最近的那个item移动的位移的方式进行
    local delta = cc.p(0,0)
    local closerItem = self:getCloserItem()
    local posX = closerItem.pLayer:gposx()
    local moveDelta = cc.pMul(cc.p(posX,0),-1)
    self:moveAllItems(moveDelta)
end

--- 把所有item限制在区域内,如果往左滑,超出区域后就把第一个放在最后;往右滑,就把最后一个放到第一个位置;
function UiCycleView:restraintItems()
    local leftBorder = -self.itemSize.width
    local rightBorder = self.touchRect.width
    local count = #self.itemViewList
    local first = self.itemViewList[1].pLayer
    local last = self.itemViewList[count].pLayer
    -- 第一个item超出了边界
    if first:gposx() <= leftBorder then
        local lastPosX = last:gposx()
        local posx = lastPosX + self.itemSize.width
        self:put1stItem2Last(cc.p(posx,first:gposy()))
    end

    -- 最后一个超出了边界
    if last:gposx() >= rightBorder then
        local firstPosX = first:gposx()
        local posx = firstPosX - self.itemSize.width
        self:putLastItemTo1st(cc.p(posx,last:gposy()))
    end
end

function UiCycleView:initTouchListener()
    self.LayerTopTouch:setTouchEnabled(false)
    local touchLayer = tolua.cast(self.LayerTopTouch, "cc.Layer")
    touchLayer:onTouch( function(event)
        if event.name == "began" then
            return self:touchStart(event)
        elseif event.name == "moved" then
            self:touchMove(event)
        elseif event.name == "ended" then
            self:touchEnd(event)
        end
    end, false, true)
    self.touchLayer = touchLayer
end

-- 日，这是一个全局的区域，所以得判断是否在区域内
function UiCycleView:touchStart(event)
    local p = cc.p(event.x,event.y)
    self.beginPos = p
    local ans = self:isInRect(p)
    if ans then
        self.fsm:transfer(EnumCycleState.Touching)
        self:dispatchEvents(EnumClickEvent.Start,p)
    end
    return ans
end

function UiCycleView:touchMove(event)
    if self.fsm:getCurState():getTag() == EnumCycleState.RestraintRolling then
        return
    end

    local delta = cc.p(event.x - self.beginPos.x,event.y - self.beginPos.y)
    self.touchDelta = delta

    self.beginPos.x = event.x
    self.beginPos.y = event.y

    self:moveAllItems(self.touchDelta)
end

function UiCycleView:touchEnd(event)
    if self.fsm:getCurState():getTag() == EnumCycleState.Touching then
        self.fsm:transfer(EnumCycleState.ResettingView)
        self:dispatchEvents(EnumClickEvent.End,cc.p(event.x,event.y))
        self.beginPos = cc.p(0,0)
    end
end

function UiCycleView:update(deltaTime)
    self.fsm:update(deltaTime)
end

-- 给item注册点击事件（是根据点是否在其区域内来的）
function UiCycleView:addItemClickHandler(view)
    local size = view.LayerTouch:getContentSize()
    view.clicked = false
    view.rect = cc.rect(0,0,size.width,size.height)
    view.isInRect = function (view,pos)
        local lp = Common.wp2Lp(view.LayerTouch,pos)
        return cc.rectContainsPoint(view.rect,lp)
    end
    view.onClickEvent = function (view,event)
        if not view:isInRect(event.pos) then
            view.click = false
            if view.ButtonItemCancelCallBack then
                view:ButtonItemCancelCallBack()
            end
            return
        end

        local eventName = event.name
        if eventName == "start" then
            if view.ButtonItemBeganCallBack then
                view:ButtonItemBeganCallBack()
            end
            view.click = true
        elseif eventName == "end" then
            if view.ButtonItemCallBack then
                view:ButtonItemCallBack()
            end
            view.click = false
        end
    end
end

-- 给容器子view派发事件
function UiCycleView:dispatchEvents(eventName,pos)
    local event = {
        name = eventName,
        pos = pos
    }

    for i = 1, #self.itemViewList do
        local view = self.itemViewList[i]
        if view.onClickEvent then
            view:onClickEvent(event)
        end
    end
end
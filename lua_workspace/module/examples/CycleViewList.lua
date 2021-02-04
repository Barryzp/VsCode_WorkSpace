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
    -- 自动滚动(普通版本)
    AutoRolling = 1,
    -- 自动滚动(缓动版本)
    EasingRolling = 6,
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
    Cancel = "cancel",
    End = "end"
}

local CycleViewState = class("CycleViewState",IState)
local IdleState = class("IdleState",CycleViewState)
local AutoRollState = class("AutoRollState",CycleViewState)
local NoRollState = class("NoRollState",CycleViewState)
local TouchingState = class("TouchingState",IdleState)
local ResetingState = class("ResetingState",CycleViewState)
local RestraintState = class("RestraintState",IdleState)
local EasingRollState = class("EasingRollState",CycleViewState)

local CycleViewFsm = class("CycleViewFsm",SimpleFsm)
function CycleViewFsm:transfer(tag,...)
    if self.tCurState then
        local curStateTag = self.tCurState:getTag()
        if curStateTag == EnumCycleState.RestraintRolling then
            return
        end 
    end

    SimpleFsm.transfer(self,tag,...)
end

function CycleViewState.init(self,view)
    self.view = view
    self.timeCounter = 0
end

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

function EasingRollState:onEnter()
    self.timeCounter = 0
    self.shift = self.view.moveShift
    self.moveDelta = cc.p(0,0)
    self.easingFun = self.view.easingFun
end

function EasingRollState:onUpdate(dt)
    self.timeCounter = self.timeCounter + dt
    if self.timeCounter >= self.view.config.moveDura then
        self.view.fsm:transfer(EnumCycleState.NoRolling)
        return
    end

    local ratio = self.easingFun(self.timeCounter/self.view.config.moveDura)
    local destShift = cc.pMul(self.shift,ratio)
    local delta = cc.pSub(destShift,self.moveDelta)
    self.moveDelta = cc.pAdd(self.moveDelta,delta)
    -- 滚动~
    self.view:moveAllItems(delta)
end

function NoRollState:onEnter()
    self.timeCounter = 0
    self.view:correctToRightPos()
end

--[[
    math1:
        how to project?
        first of all:basic learning.
        23题:aim 120
        choose(8*4 = 32),fill(6*4 = 24),answer(5*10 + 4*11 = 94)
        稍微加深，广一点
        藐视（概率），不管学过没有学过，这个统一没学过，见效快，紧盯高数
        math:82-56%,linear:34-22%,prob:34-22%
        值得投入math
        math:(4*4choose,4*4fill,5*10answer)
        现在目前不用管linear

        共同：
        （1）*极限与连续*(10+)
        （2）一元微分学(导数与微分)，*中值定理与一元函数微分应用*(*有难度的)20+
        （3）一元积分（不定积分+ *定积分*）
        （4）二重积分（少，单一）
        （5）多元微分学及应用（难度不大）
        （6）*微分方程*（重点）
        一（*机会与风险并存*）
        （1）常数项级数
        （2）幂级数
        （3）三重积分
        （4）空间解析几何
        （5）傅里叶级数
        （6）曲线曲面积分
    阶段：
        入门阶段：教材，每一章的基本概念，原理，重点，习题略做一点：目标：心中有数
        基础阶段（非常重要，老师很重要）：1-6月底
            理解基本概念（理解和了解差距非常大）
            理解基本原理以及性质
            理解基本题型以及方法
        强化阶段（非常重要）：走向成熟，4大任务
            （1）计算能力：
                解决任何问题用最佳解题技巧，最小的运算量
                对性质，方法掌握得很快
            （2）综合分析能力：
                准确把握题目条件，听懂人家得话
                各种考点
                综合串起来
            （3）逻辑推理能力：证明
            （4）实际应用能力
    学习方法：
        建立框架structure，基础概念，基础性质心中明了
        建立方法体系，找主要矛盾，核心问题，找出解决方案
        用巧劲！
    多练习
]]
function NoRollState:onUpdate(dt)
    self.timeCounter = self.timeCounter + dt
    if self.timeCounter >= self.view.config.stayDura then
        if self.view.easingFun then
            self.view.fsm:transfer(EnumCycleState.EasingRolling)
        else
            self.view.fsm:transfer(EnumCycleState.AutoRolling)
        end
    end
end

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


function UiCycleView:ctor()
    XViewBase.ctor(self)

    self:resetData()
    self:registerFsm()
end

function UiCycleView:resetData()
    self.touchLayer = nil

    self.itemSize = cc.size(0,0)            -- 移动item大小
    self.touchRect = cc.rect(0,0,0,0)       -- 触摸区域

    self.beginPos = cc.p(0,0)               -- 触摸起始点
    self.touchDelta = cc.p(0,0)             -- 触摸位移

    self.speed = cc.p(0,0)                  -- item移动速度
    self.resetSpeed = cc.p(0,0)             -- 重置速度
    self.moveShift = cc.p(0,0)              -- 单位时间内移动的位移
    self.isClick = false                    -- 是否点击

    self.firstIdx = 0                       -- 当前循环列表中的第一个item
    self.lastIdx = 0                        -- 当前循环列表中的最后一个item
    self.itemViewList = {}
    self.config = {}
end

function UiCycleView:registerFsm()
    local allState = {
        [EnumCycleState.None] = IdleState,
        [EnumCycleState.AutoRolling] = AutoRollState,
        [EnumCycleState.NoRolling] = NoRollState,
        [EnumCycleState.Touching] = TouchingState,
        [EnumCycleState.ResettingView] = ResetingState,
        [EnumCycleState.RestraintRolling] = RestraintState,
        [EnumCycleState.EasingRolling] = EasingRollState,
    }

    self.fsm = CycleViewFsm.new()
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
        showNum,        -- item的显示个数
        stayDura,       -- 停留时间
        speed = {
            moveDura,   -- 移动时间
            -- 下面两个参数是任意一个填充任意一个就行，如果都填了以moveDelta为准
            moveUnit,   -- 移动单位（在moveDura内移动moveUnit个item），[注意要不大于生成个数]
            moveDelta,  -- 移动位移
        },
        resetInterval   -- 重置时间(默认为0.1)
        touchSize,      -- 触摸范围，默认为展示数目的大小之和
        easingFun,      -- 缓动函数，也可以是自定义的一个函数
                           (需要注意的是其参数是在[0,1]的，并且值域也应该是[0,1]的函数)
    }
]]
function UiCycleView:setListView(config)
    self:initConfig(config)

    self:spawnItems()
    self:setInfo()
    self:correctItemPos()

    self:initTouchListener()
    self.fsm:transfer(EnumCycleState.NoRolling)
end

function UiCycleView:initConfig(config)
    config.itemNum = #config.itemDatas
    if config.itemNum > 2 and config.itemNum < config.showNum + 1 then
        -- 把数据再注入一遍，防止重复部分没有刷出来
        for i = 1, #config.itemDatas do
            local data = config.itemDatas[i]
            array.push(config.itemDatas,data)
        end
    end
    config.itemNum = #config.itemDatas

    self.config = config
    self.config.moveDura = self.config.speed.moveDura
    self.config.resetInterval = self.config.resetInterval or 0.1
    self.easingFun = config.easingFun
end

-- 生成item?
function UiCycleView:spawnItems()
    local config = self.config
    local showNum = config.showNum
    if #config.itemDatas <= 2 then
        -- 不准动
        self.fsm:transfer(EnumCycleState.RestraintRolling)
        showNum = config.itemNum - 1
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

function UiCycleView:setInfo()
    local config = self.config
    local itemSize = self.itemViewList[1].LayerTouch:getContentSize()
    self.itemSize = itemSize
    local touchWidth = config.showNum * itemSize.width
    -- 暂时不管竖直方向
    local touchHeight = itemSize.height
    local touchSize = cc.size(touchWidth,touchHeight)
    if config.touchSize then
        touchSize = config.touchSize
    end

    local wp = Common.getWPos(self.LayerContent)
    self.touchRect = cc.rect(wp.x,wp.y,touchSize.width,touchSize.height)
    self.LayerContent:setContentSize(touchSize)
    self.LayerTopTouch:setContentSize(touchSize)

    local shift = cc.p(0,0)
    if config.speed.moveUnit then
        shift = cc.p(config.speed.moveUnit * itemSize.width,0)
    end
    if config.speed.moveDelta then
        shift = config.speed.moveDelta
    end

    self.speed = cc.pMul(shift,1/config.speed.moveDura)
    local dir = cond(config.speed.moveDura > 0,1,-1)
    self.moveShift = cc.pMul(shift,dir)
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

-- 估值失效（近期盈利下滑），用之前的数据
-- 价值平均策略
-- 估值平均策略（针对于指数基金）
-- 算法，算力（AI算法，AI框架，AI芯片）
-- 新能源
-- 信息，物质，能量，自动驾驶，智慧城市
-- 银行

-- 价值定投法
-- 张坤管理的易方达中小盘以386.40%的收益率，成为全市场近五年来收益率最高的主动权益类基金。

-- 慧定投
-- 定值定投，

-- 均衡配置

-- 1)周期板块中，关注受益于经济回升，库存回补，行业格局优化的有色、化工、建材；
-- 2)消费板块中，关注耐用消费品中的汽车、家电、白酒。
-- 3)成长板块中，关注产业趋势明确，订单饱满，未来2—3年持续高景气的消费电子(面板、半导体、苹果产业链)，新能源、新能源汽车以及军工板块。

-- 引导孩子

-- 什么时候卖出
--[[
    1.收益率：达到自己的收益率，到达目的收益，就赎回（注意赎回费率）
        不能设置得太低，
        30%常用：为什么
        可转债：可转成股票，自带30%止盈策略，由于和宽基指数很相似，可以用来参考
        适合波动大的，适合2-3年内的需要用钱的
        证券，能源
    2.按照高估值止盈
    大牛市10年左右
    （1）在牛市收益高
    （2）能够享受到其本身带来的盈利增长和分红积累
    缺点：需要耐心，大牛市需要10年，不为波动所动
    对品种有要求，不适合增长慢的品种，
    红利、基本面、低波动等等策略指数
    优秀的行业指数，医药，消费，中概互联等（7~10年止盈一次）
    3.梯度止盈（分批卖出）
    4.长期持有（靠现金分红）
    心理素质得高 = _> =
    适合股息率高，分红高，且稳定的基金
    在低估，股息率高的时候投资，
]]

--[[
    完整的定投计划：
    step1：
        梳理自己的现金流，做好3年以上的准备，金额要选择合适
        不超过剩余金额的一半，留出备用金
    2:
        选择渠道进行
    3：
        确定时间和频率
    4：
        详细地列出来严格执行，避免主观情绪地干扰
    5：
        在实践过程中进行优化和改进
    6：
        给别人讲，促进知识吸收

    养老配置
    30%：低估指数基金，分批投资
    70%：货币基金

    保本投资策略

    教育定投计划

    财商教育：
    正确的消费观，存钱，延迟享受
    把自己变成优秀资产或者是购买优秀资产
    提升自己的能力资产价值，

    根据工作配置股性资产还是债性资产

    指数基金ABC类啥意思：代表收费方式
        A：买入收费（长期持有）
        B：卖出收费
        C：不收费，收管理费（短期买卖）
    A和C有惩罚费率，
    短期买卖买场内ETF
]]

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

function UiCycleView:getDataByIdx(idx)
    local datas = self.config.itemDatas
    return datas[idx % (self.config.itemNum + 1)]
end

-- 给item注册点击事件（是根据点是否在其区域内来的）
function UiCycleView:addItemClickHandler(view)
    local size = view.LayerTouch:getContentSize()
    view.rect = cc.rect(0,0,size.width,size.height)
    view.isInRect = function (view,pos)
        local lp = Common.wp2Lp(view.LayerTouch,pos)
        return cc.rectContainsPoint(view.rect,lp)
    end
    view.onClickEvent = function (view,event)
        if not view:isInRect(event.pos) then
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
        elseif eventName == "cancel" then
            if view.ButtonItemCancelCallBack then
                view:ButtonItemCancelCallBack()
            end
        elseif eventName == "end" then
            if view.ButtonItemCallBack then
                view:ButtonItemCallBack()
            end
        end
    end
end

-- 日，这是一个全局的区域，所以得判断是否在区域内
function UiCycleView:touchStart(event)
    local p = cc.p(event.x,event.y)
    self.beginPos = p
    local ans = self:isInRect(p)
    if ans then
        self.fsm:transfer(EnumCycleState.Touching)
        self:dispatchEvents(EnumClickEvent.Start,p)
        self.isClick = true
    end
    return ans
end

function UiCycleView:touchMove(event)
    local delta = cc.p(event.x - self.beginPos.x,event.y - self.beginPos.y)
    local length = cc.pGetLength(delta)
    if length >= 0 then
        self.isClick = false
    end

    if self.fsm:getCurState():getTag() == EnumCycleState.RestraintRolling then
        return
    end

    self.touchDelta = delta

    self.beginPos.x = event.x
    self.beginPos.y = event.y

    self:moveAllItems(self.touchDelta)
end

function UiCycleView:touchEnd(event)
    local stateTag = self.fsm:getCurState():getTag()
    if stateTag == EnumCycleState.Touching 
    or stateTag == EnumCycleState.RestraintRolling
    then
        self.fsm:transfer(EnumCycleState.ResettingView)
        if self.isClick then
            self:dispatchEvents(EnumClickEvent.End,cc.p(event.x,event.y))
        else 
            self:dispatchEvents(EnumClickEvent.Cancel,cc.p(event.x,event.y))
        end
        self.beginPos = cc.p(0,0)
    end
    self.isClick = false
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

--- 把所有item限制在区域内,如果往左滑,超出区域后就把第一个放在最后;往右滑,就把最后一个放到第一个位置;
function UiCycleView:restraintItems()
    local leftBorder = -self.itemSize.width
    local rightBorder = self.config.showNum * self.itemSize.width
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
    local closerItem = self:getCloserItem()
    local posX = closerItem.pLayer:gposx()
    local moveDelta = cc.pMul(cc.p(posX,0),-1)
    self:moveAllItems(moveDelta)
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

--[[
    基础阶段-6月，必须完成一遍英语单词
    以及：
    语法长难句：田静/刘晓艳
    阅读方法论：阅读方法论

    强化阶段：7-8
    前期：
    阅读真题
    写作方法论
    后期：
]]

function UiCycleView:update(deltaTime)
    self.fsm:update(deltaTime)
end
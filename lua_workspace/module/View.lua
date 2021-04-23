--[[
EnumViewType = 
{
    -- 地图
    Map = 1,
    -- 手势
    Touch = 2,
    -- 装饰层
    Cover = 3,
    -- 通用层
    Main = 4,
    -- 全屏框架
    FrameFull = 5,
    -- 框架
    Frame = 6,
    -- 弹窗
    Dialog = 7,
    -- 引导
    Tutorial = 8,
    -- 遮罩
    Shade = 9,
}

主要思路是这样的：
            <-XViewFrame
XViewBase   <-XViewCover
            <-XViewDialog
            <-XViewFrameFull
            <-XViewMain
            <-XViewDialog

每一个层就把对应的界面压进对应的层中，这又形成了一个层级

]]


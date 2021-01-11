遥感以及按钮的相关生成：Gamepad

真正的ECS是个啥：
    Entity:各个Component的桥梁
    Component:包含着Data
    System:承载逻辑的地方
见这一篇文章：知乎我的收藏->游戏及图形学
传统OOP存在的缺陷：
首先第一点：组合由于继承

关于逻辑帧，渲染帧
都是在GameManager中进行定时Schedule update的。
对于实体相关数据：
    为 EntityManager.update->EntityRole.update->Components.update,这些是在MapEntity地图实体中进行每帧刷新的
    
    GameManager->
    SceneManagerExternal.update->
    LayerManager.update(更新所有的Layer)->
    LayerMap.update->
    MapManager.update->
    MapEntity.update->
    EntityManager.update->
    EntityRole.update->
    Components.update


行为树：
    Composite节点中有AddCondition方法可以用于添加判断条件

行为树的逻辑更新：
    Selector.update->其子节点也随着更新

1.Leanring stuff in company:
    (1)To figure out how player act
        fight
        action,

    (1)The framework
        fight,scene,
    (2)Ai
    (3)
    ()
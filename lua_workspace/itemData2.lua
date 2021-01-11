-- 爆气动画的调用栈：
-- 属于玩家角色的行为树：
EntityRole:update()
BehaviorTree:update(delta)
ActionBase:update()
AttackRole:execute()
AttackRole:dealWithSkillSpine()
CameraManager:startFreeze(freezeId)

-- 神器技能
-- 是通过UI事件进行分发，和技能相关东西不太一样

--！！！需要看一下技能的释放了！
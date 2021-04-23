武装基本概念：
神器就是武装（神器是以前的概念，武装是现在的概念）
玩家有6个武装槽可用于安装武装
玩家可以携带已安装武装种的2个武装主动技能以及4个被动技能进入游戏（点击武装配置）
主城玩家显示的是第1把武装，武装姬也是第1把武装才能显示

对武装培养有3种，升级和升星
升级和进阶是针对于武装槽的属性加成，升星是针对武装本身的

武装升级：升到指定等级需要进阶
武装进阶：需要安装对应阶数进阶材料才可进阶
进阶材料可以通过扫荡或通关指定副本获得
武装升星：武装升星有几个阶段
第一阶段升级普通大星，普通大星分为几个小星，升到5星时开始升品
第二阶段是升品，低于SSR的武装升品质到SSR就开始升UR品
第三阶段是UR升星，这个时候的升星直接就是升UR的大星
实际上武装的星数是1-10,如果stars<=5那么就是属于升星或升品,如果stars>5就是UR品质阶段的升星

武装连携技能，特定的武装搭配之后可以触发连携技能
连携技能有3种类型，
第一种类型是若干个武装组合
第二种类型是制造商组合
第三种类型是特性组合

大星数：1-5（分为UR的五星和非UR的五星）
小星数：0-5（非UR升星时没课大星分为6颗小星，UR升星时是直接升大星）
实际星数：1-10（5星以上就是UR了）

武装数据类：CacheArtifact继承于CacheArtifactBase
CacheArtifactBase：设计目的：沿袭之前的神器系统，之前的老哥喜欢直接创建一个类来处理数据
包括战斗内也一样，个人认为还是有一定的道理：
（1）创建了一个类之后可以使用其相关的方法，就免得重新再战斗里写一套取数据的方法，
比如说当前的武装技能id，当前武装是否装备武装姬之类的。
（2）涉及到很多地方都是这样使用的(比如说创建人物UI模型等等)，统一改会修改很多地方，因此就沿袭之前的方案
（3）CacheArtifact对CacheArtifactBase来说多了协议处理和武装整个UI系统的界面显示的数据处理相关
而CacheArtifactBase只涉及到数据处理

-- 获取武装的当前品质（如果未拥有，获取的就是初始品质）
function CacheArtifactBase:getQualityOfArtifact(artifactId)
-- 意思是武装是否配置有武装姬
function CacheArtifactBase:hasSkin(armId,roleType)
-- 获取武装配置里所有的武装姬id
function CacheArtifactBase:getSkins(armId)
-- 获取已获得的某个武装的信息，armId为nil，返回的是所有已获得的武装
function CacheArtifactBase:getObtainedArmInfo(armId)
-- 获取武装收集状态，用于是否增加收集属性的判断
function CacheArtifactBase:getCollectStatus(armId)

CacheArtifact:
function CacheArtifact:initConfig()
这个方法的主要作用是处理数据：
（1）把所有武装的武装id存起来，存到tArtifactIdList中
（2）把所有的武装姬id存起来，存到tSkinIdList中
（3）orgnizedUpStarConfigs：对升星表（item_artifact_starup）中的升星信息进行处理：
    升星放一类，升品放一类。（通过升星信息的type字段进行区分（1：升星，2：升品））
    升星通过构造一个键值 “初始品质-当前品质-大星数目-小星数”:id
    而升品则是构造一个键值“初始品质-当前品质”:id
（4）initAdvanceConfig：整理武装进阶数据(item_artifact_progress)
    因为需要展示进阶时的累计数据，所以需要把进阶时加的相关属性值加上去，这个方法时用来
    遍历整个进阶表，然后计算每个阶的累计增加的属性值的
（5）initArmGrade2MaxLevelMap：对武装升级表（item_artifact_level）进行整理，
    构造一张品阶对应最大等级的表，通过getGradeMaxLevel就可以获取了，但是对于最后一个阶
    需要特殊处理一下

-- 获取某个品质的下一品质，品质已经在配置表中配置了的
function CacheArtifact:getNextUpQuality(curQuality)

-- 获取某个品质的前一品质
function CacheArtifact:getPreQuality(quality)

-- 获取武装升星的升星信息
function CacheArtifact:getUpStarInfo(initQual, curQual, bigStarLv, littleStar)
这样读取的：
    我们通过初始品质，当前品质，大星和小星数去获得当前额升星信息upStarInfo
    如果star_up为0说明是升小星，为1代表升大星，为2的话就说明是升品了，就不能用这个upStarInfo，
    需要根据初始品质和当前品质去upgradeMap中取对应的升星信息id
返回值有3个参数：
    info：升星信息
    resCode：返回码， 1(正常升星)，2(升品质)，3(已达最高阶)
    directInfo：针对于升品时候查找升星信息有一层转化，这个值取的是转化前的值

-- 获取下一阶段的升星信息
function CacheArtifact:getNextUpStarInfo(initQual, curQual, bigStarLv, littleStar)
根据升星类型来区分下一阶段是哪些情况从而获取相关信息。

-- 获取某个武装的所有类型及所有等级技能信息，用于技能显示
function CacheArtifact:getStar2SkillsOfArmMap(armId)
    constructSkillInfo：构造一个技能信息的数据结构，包括等级，技能id，需要达到的星级，技能描述等
    返回值：每种类型的技能信息的数组

-- 获取进阶相关材料信息，这个方法是用来构造武装进阶材料的信息（用于武装进阶界面）
function CacheArtifact:getInstallItemsInfo(slotInfo)
slotInfo是武装的槽信息，可以通过getSlotInfo方法来获得
这个方法的逻辑是这样的，先把已安装的材料遍历到installedMatIds中，然后和当前阶需要的
进阶材料比较，可以得出这个材料的状态是否为已安装，否则如果材料数量大于0，那么显示可安装
武装进阶材料有若干状态：
已安装：。。。
可安装：。。。
前面两种状态判断失败时，还有以下两种状态
可扫荡：材料可通过相关副本扫荡获得
未开启：材料对应的相关副本都未解锁扫荡或未解锁关卡

以上只是针对与单个，可直接扫荡获得的，对于需要合成的扫荡材料，其可扫荡状态和未开启状态
是这样判断的：
对于合成材料来讲，两个子材料都可以被扫荡则这里显示“可扫荡”。
只要任意一个材料是可获得这里就显示“可获得”
只要任意一个材料是未开启这里就显示“未开启”
优先级:未开启>可获得>可扫荡

function CacheArtifact:orgnizedArmsComboInfo(armIds)
-- 构造一组武装所拥有的连携技能相关特性以及阵营的数量，用于比较
这个需求是这样的，武装有连携技能，连携技能有三种类型
若干个武装的搭配
若干个制造商的搭配
若干个武装特性的搭配
在某些地方客户端需要比较是否已解锁连携技能，或者是在换武装的时候替换哪个武装可以激活相应的
连携技能

我的逻辑就是将当前已穿戴的所有武装的特性，制造商的数量加起来，然后和某把武装的连携技能所需要
的特性，制造商等进行比较，从而得到是否可以激活。

-- 构造某个武装的连携技能所需要的特性数量
function CacheArtifact:organizeComboNeedNum(armId)

-- 获取当前技能槽上的连携技能信息(比如当前武装槽上所有特性的数目，或者是制造商的数目，用于显示连写技能解锁与否)
function CacheArtifact:getCurrentComboSkillInfo()

-- otherArmIds这堆武装是否能够激活armId的连携技能
function CacheArtifact:canReplaceToActiveCombo(armId, otherArmIds)

接下来就是武装升星界面的升星界面的提示里相关数据的计算
-- 获取当前大星增加的属性值(非UR时升星调用)，stars指的是大星数，不是实际星数
比如说stars的值若为5，那么这个delta的值就是从1.0到5.0中所增加的累积所有值
function CacheArtifact:getDeltaFromLastStars(armId, stars, curQuality)

-- 获取UR大星累计提升的属性百分比，stars指的是大星数，不是实际星数（stars从2星开始，
因为UR1星有额外的界面处理）
function CacheArtifact:getDeltaFromStarsUr(armId, stars, valType)

--[[
    获取升星技能改变信息
    realStars是真实星数
    返回的是上一星级到当前星级时，如果某个技能升级了，
    那么就会有上一个技能和当前这个技能的数据
    这个是用于升星界面时的技能展示，一般来说每升一颗星都会升级一个技能
]]
function CacheArtifact:getUpStarSkillChanges(armId, realStar)

-- 获取升品质的时候的属性增加值
-- 第一次升品时上一等级的属性值时当前槽上的值，之后才是和上一次升品增加的属性值
function CacheArtifact:getUpQualityAddValsNotUr(armId, preQuality)
逻辑是这样的：先去取1-5星的累计属性值，然后通过递归的方式再去取品质相关项的累加属性值

-- 武装槽信息改变的通知
function CacheArtifact:noticeForSlotInfosChanged(infos)
-- 如果有未装配的武装姬就显示红点
function CacheArtifact:getMainUiSkinRedPoint(position)
-- 显示可收集属性的红点（有收集属性为未激活和可提升时的武装时显示）
function CacheArtifact:getCollectAttriRed()
-- 是否能直接升大星（非UR），这个是用于判断图鉴中的升星状态是否显示，所以需要计算每颗
小星所需要的升星材料
function CacheArtifact:canUpBigStar(armId)
-- 是否武装可以升星（下一阶段的升星，包括小星，大星，升品），与canUpBigStar的区别是
后者是判断非UR时是否可以直接升到下一颗大星
function CacheArtifact:canUpStar(armId)

是否某个槽能够直接升lvDelta级，
function CacheArtifact:canSlotUpToLevel(position, lvDelta)
-- 获取皮肤按钮红点：如果皮肤已经激活，并且是永久皮肤，如果有多余的激活道具，就需要显示

武装工具类：UiGodWeaponUtil
由于武装系统有很多地方的功能需求相似，因此把常用方法封装在这个类里面供外面的UI类调用

打开武装界面
menuTag：菜单栏项（定义在CacheArtifact中）
slotPosition：武装槽槽位
function UiGodWeaponUtil.pushView(menuTag, slotPosition)
设置遮罩状态
function UiGodWeaponUtil.setMainUiMask(state)
生成星星spine，view是相关ui类的引用
function UiGodWeaponUtil.spawnStarSpine(view)
生成技能等级图标spine，如觉醒，lv1，等等的spine
view：ui类，nodeName：节点名
function UiGodWeaponUtil.spawnSkillLvSpine(view, nodeName)
生成武装背景spine
function UiGodWeaponUtil.spawnArmBgSpine(view, nodeName)
播放武装背景spine动画
function UiGodWeaponUtil.playArmBgSpine(spine, armId)
武装主界面一上一下的动作效果
function UiGodWeaponUtil.doArmMoveAction(node)
设置武装星星的数量和背景，quality：品质，starNum：大星数（1~5）
function UiGodWeaponUtil.setStars(view, quality, starNum)
通过实际星数（1~10）设置武装星星的数量和背景
function UiGodWeaponUtil.setStarsByRealStar(view, starNum)



武装主界面
UiGodWeaponMainNew1
分为3个部分：左侧是武装槽，中间是当前槽对应的武装，右侧是武装相关培养界面
选择某个槽，然后培养界面会刷新相应视图
function UiGodWeaponMainNew1:selectSlot(position)
跳转到某个培养菜单的某个菜单栏menuTag:EnumArmUpMenuTag.xxx
function UiGodWeaponMainNew1:jumpMenu(menuTag)
为了兼容培养相关的界面，就采用了这样的方式来构造数据
function UiGodWeaponMainNew1:consturctViewInfo(slotInfo)
切换武装时如果有新的连携技能就会抛出一个事件响应次方法：
次方法会将所有新的连携技能id放入一个数组中，界面打开一个弹出状态则设置为false，
直到到全部的连携技能都为false时清空数组
function UiGodWeaponMainNew1:onComboSkillUpdate(comboSkillIds, armIds)
（1）由于武装培养的时候会有播放一些动画，如果在播放动画的时候允许界面操作那么
会出现一些BUG，所以这个地方设置了一个方法用于弹出屏蔽层
（2）有一个需求就是升星的时候武装槽位要等特效播放完才刷新，因此多加了一个状态bNotRefresh
来进行控制
function UiGodWeaponMainNew1:setTouchMask(state)

UiGodWeaponUpDetail
武装详情ui，这里面没什么逻辑，只是一些ui的显示

UiGodWeaponUpLv
武装升级ui
如果升级10次没有红点，点击升级10次实际上是会升级到材料用完时的那一级
具体逻辑就是从当前这个等级开始进行判断，直到材料不足或阶数和当前阶数不等为止
function UiGodWeaponUpLv:maxUpLv()
maxLv-1的原因是当前等级的升级材料代表的是升到下一等级的材料
addNeedMat():这个函数会计算需要的材料数量，同时也会判断材料是否足够，返回值就是这个布尔值
最后得到的couldUpLv就是能升到的级数，还是由于当前等级的升级材料代表的是升到下一等级的材料，
因此正常情况下couldLv还需要加个1。
由于点击升级10次需要显示升了多少级的提示，因此加了一个isClick10Btn的变量用于判断

UiGodWeaponUpGrade
武装进阶ui
UiGodWeaponUpGrade:setAttributeUi():设置属性值，逻辑是这样的：获取已经安装的所有材料，
然后把所有的材料增加的属性都存起来展示，当所有材料都已安装完毕还需要加上额外的增加值。

UiGodWeaponUpStar
先解释以下为啥写refreshAll这个方法，因为一个需求：播放特效之前玩家得看到升星材料得变化。
refreshUiExceptNeedMats():如其名，除了材料之外得UI刷新，而各个升星状态的界面也不同
refreshNeedMats():如其名，刷新所需要得材料数量
setUpStarNeedMatsUr(upStarInfo):设置->UR升品或UR升星材料
setUpStarNeedMatsNotUr(upStarInfo, upType):设置普通升星或升品材料

升星按照表现可以分为：
升小星(EnumArtifactUpStarType.UpStarLittleStar)
升大星(EnumArtifactUpStarType.UpStarNotUr)
升品质(EnumArtifactUpStarType.UpQualityNotUr)
升UR品(EnumArtifactUpStarType.UpQualityUr)
UR升星(EnumArtifactUpStarType.UpStarUr)

每一次得升星相应都会触发onUpStarSucc方法，preStarInfo代表的是上一次的升星信息，具体数据结构
可查看CacheArtifact:reqForUpgradeStarContinuely(...)这个方法
uiType是用于分辨是武装系统(UiGodWeaponMainNew1)的升星页面还是升星页面(UiGodWeaponMainUpStar)
如果不加区分会有一个BUG，在打开武装系统的升星界面的情况下，再跑到图鉴升星中去点击升星，
这时升星界面会弹两次。

UiGodWeaponUpStar:showFightTips():关于战斗力提示的特殊处理，以前的战斗力提升是只要有增加
就会弹出提示，但是武装升星这一块需要在特效播放完毕之后再弹出增加的数值，所以这里又进行了处理，
处理逻辑可以查看CacheArtifact:setUpStarPlayingState(isPlaying)后面的相关方法

self:pushUpStarSuccView:根据当前升星状态弹出对应的升星成功界面
（这个升星界面有几种...，相似处也少，数值显示以及计算都不一样）

UiGodWeaponUpStar:playLittleStarAni(firstStar, finalStar, bigStar):播放小星闪烁的效果
UiGodWeaponUpStar:pushUpStarSuccViewSub():弹出升大星成功，包括普通大星和UR大星
UiGodWeaponUpStar:pushUpQualitySuccViewNotUr():弹出非UR升品成功界面
UiGodWeaponUpStar:pushUpQualitySuccViewUr():SSR->UR升品

UiGodWeaponUpStar:upStarNoStoping():连续升小星，如果材料足够，那么会升到下一颗大星
计算逻辑还是和武装升级一样，加到多少是多少

UiGodWeaponChoose:更换武装界面
在更换武装界面时需要显示更换哪一把武装可以激活连携技能，所以需要传入武装槽的位置，用于
得到其余的武装id

UiGodWeaponHandBook:武装图鉴
这里面的武装排序有些复杂，具体看
UiGodWeaponHandBook:sortArms(id1, id2)的注释

有个需求就是：已拥有和可合成的需要与未拥有的分开，中间有一条线，这个就不能复用了
具体方法是：对已经排序了的索引数组进行搜索，直到找到未拥有的第一个，这个索引就作为分界
allRows:总的行数
divideRow:分界的那一行
lineIndex用来记录每行的第一个武装item的索引，因为在分界的那一行，可能不是满的，这个就在
那一行中自己来进行计算，返回值就是下一个的索引

UiGodWeaponSkillInfoDetail:技能详情弹窗
主要逻辑是遍历某把武装的星级信息，然后根据技能类型将skill_effect字段的内容读取出来显示
对于解锁显示skill_effect字段，未解锁显示skill_effect_colse字段
然后设置技能数据，由于不同技能item的文本size不等，所以需要根据长度重新设置位置。
resetWidgetPos:重新设置各个组件的位置，实际上整个位置的计算是根据背景ImageSkillBg来
确定的，ImageSkillBg的大小设置完毕之后，我们计算得到左顶点和右底点的位置，然后顶部位置
的y值则为左顶点减去顶部区域的高度，同理，ListViewSkillInfo的y值直接为右底点的y值(因为锚点是(0,0))

UiGodWeaponDetailShow
这个其实包括武装的展示和武装姬的展示，详情可以看ui

UiGodWeaponBattleFormation
武装技能搭配：
触摸移动就是盖了一层触摸层LayerTopTouch，然后在上面注册触摸事件监听，关于触摸区域的判定
也就是比对触摸的那一点是不是在LayerArtifactX中，如果在就更换，在退出界面时才会发搭配武装的协议。

UiGodWeaponBattleFormation:touchStart(event):触摸区域开始，如果触摸点在触摸区域内，
则代表可以触发接下来的触摸移动方法。
设置层级的原因是当前拖动的这把武装应该位于最高层，这样才不会被挡住
UiGodWeaponBattleFormation:canDrag():这个方法用于判断是否可以拖拽，原理就是判断触摸点是否
在显示的武装所代表的区域内。如果在，就返回true以及匹配的item的index
UiGodWeaponBattleFormation:touchMove(event):移动对应的武装图标
UiGodWeaponBattleFormation:touchEnd(event):手指抬起时，如果当前的点在指定的武装区域
内那么就交换两个武装。

UiGodWeaponAccessWay1New
UiGodWeaponAccessSweepScroll
UiGodWeaponFatterSkillList

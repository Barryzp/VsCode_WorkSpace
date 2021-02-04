界面处理完全可以借助状态机来实现
TP:搓出招需要的蓝
EP:爆气需要的那玩意儿

    写好代码的101个方法：   
    1.编写经得起修改的代码
        (1)Keep it simple或者是keep it short and simple,代码保持简洁
        (2)现在用不到的代码就不应该现在写，因为在大多数情况下，将来也用不到
        (3)不用擅自添加需求（需求不是我们确定的，是用户确定的）
        (4)奥卡姆剃刀，当一个食物存在多种解释时，最简单那个往往是对的

    2.DRY(Dont repeat yourself)，严禁复制粘贴代码
        (1)条件相同的控制语句的代码块
        (2)将常量写入代码里
        (3)代码的注释
    3.SLAP(Single level of abstraction principle)，单一抽象层次原则
        (1)将高级别的抽象化概念和低级别的抽象化概念分离
        (也就是说，将代码的函数变成类似于图书的目录结构，概括(抽象的方法)，章节(稍微具体的)，小节(稍微具体的方法)，还可以进一步细分)
        (2)函数结构化之后，对于函数的处理就交给比自己第一级别的函数为中心(称之为复合函数)
        (3)复合函数中切记不要又调用不同抽象级别的函数
    4.OCP(Open closed principle),开闭原则
        对扩展开放(代码的行为可以扩展)，对修改关闭(对代码的行为进行扩展时，其它代码完全不受影响)
        (1)代码应该能够灵活应对变化，只要给代码添加新行为[就能毫无风险完成对软件的修改]
        (2)给代码设置接口是一种不错的方法
    5.命名的规范，name matters!
    6.高质量代码的三个基本思想：
        交流
        简洁
        灵活性
    
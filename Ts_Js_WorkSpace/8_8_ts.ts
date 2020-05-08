//#region 函数类型接口，对函数的约束，函数实现接口，说白了，接口就相当于约束
interface StringFunIf{
    (val:string,val2:string):string;
}

let fun:StringFunIf=(val:string,val2:string)=>{
    return val+val2;
}
//#endregion

//#region 泛型类型接口 方法一：
interface AnyFunIf{
    <T>(val:T):T;
}

let fun2:AnyFunIf=<T>(val:T)=>{
    return val;
}
console.log(fun2<string>("sdasd"));
//#endregion

//#region 泛型类接口 方法二：
interface AnyFunIf2<T>{
    (val:T):T;
}

let fun3:AnyFunIf2<number>=(val:number)=>{
    return val*val;
}

let fun4=<T>(val:T)=>{
    return val;
}

//还有这种骚操作来实现
let fun5:AnyFunIf2<string>=fun4;
//#endregion

//#region 泛型类
interface ITypeTs{
    num:number;
    name:string;
}

class ClassType implements ITypeTs{
    public num:number;
    public name:string;
    constructor(aNum:number,name:string){
        this.num=aNum;
        this.name=name;
    }
}

class TestGeneric<T extends ITypeTs>{
    public val:T;
    constructor(type:T){
        this.val=type;
    }
}

enum A{
    a = 1,
    b=2
}

console.log(A[A.a]);
//#endregion
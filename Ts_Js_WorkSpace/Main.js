"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Observer_1 = require("./Observer");
const Emmiter_1 = require("./Emmiter");
const core_1 = require("./core");
class Test extends Observer_1.Observer {
    constructor(cb, ct) {
        super(cb, ct);
    }
}
class Test2 {
    constructor() {
        let self = this;
        Emmiter_1.Emmiter.Register("Test2", this.EventHandler, this);
    }
    EventHandler(eventName, args1, args2) {
        console.log(eventName, args1, args2);
        console.log(arguments);
        console.log("Event notified and this is the responses function.");
    }
}
function* yieldFunction() {
    let a = 0;
    let b = 1;
    while (true) {
        yield a;
        [a, b] = [b, a + b];
    }
}
class Property {
    constructor(p1, p2) {
        this.property1 = p1;
        this.property2 = p2;
    }
}
class ClassType {
    constructor(aNum, name) {
        this.num = aNum;
        this.name = name;
    }
}
class TestGeneric {
    constructor(type) {
        this.val = type;
    }
}
class Main {
    static fun1(value) {
        switch (typeof (value)) {
            case "number":
                console.log("number:", value);
                break;
            case "string":
                console.log("string:", value);
                break;
        }
    }
    //8.5.泛型的使用
    static getVal(val) {
        return val;
    }
    static useGeneric() {
        let temp = new TestGeneric(new ClassType(10, "sd"));
        console.log(temp);
    }
    static main() {
        //判断是否是相同类型
        // let obj1 = new core_1.Barry.Object1();
        // let obj2 = new core_1.Barry.Object2();
        // console.log("is obj1 same type of obj2? " + Object.is(obj1, obj2) ? "true" : "false");
        // let a = "name";
        // Main.getVal(11);
        // Main.getVal("string");
        // Main.useGeneric();

        let fun=[];
        for(var idx=0;idx<7;idx++){
            fun[idx]=()=>{
                return idx;
            }
        }

        console.log(fun[0]());
    }
}
Main.main();
/*let [x=10,y]=[1,2];
        let [v1,v2,v3,v4,v5]=yieldFunction();
        console.log(x,y);
        console.log(v1,v2,v3,v4,v5);*/
//解构对象，变量名应与属性名保持一致
// let {property1:property3}=new Property("001","002");/*变量名与属性名不一致需要这么搞,':'前面的属性相当于一个模式，不是变量，因此不会被赋值 */
// console.log(property3);
//解构字符串
// const [c1,c2,c3]:string="asw";
// console.log(c1,c2,c3);
//函数参数的解构
// let fun=function([x,y]:number){
//     return x+y;
// };
// console.log(fun([4,5]));
//解构的作用
//（1）交换变量的值
/*let val1=10;
let val2=20;
[val1,val2]=[val2,val1];
console.log(val1,val2);*/
//（2）从函数中返回多个值
/*let fun=function()
{
    let a=1,b=2,c=3;
    return [a,b,c];
};
let [a,b,c]=fun();
console.log(a,b,c);*/
//（3）函数参数的定义
/*let fun2=function([x,y,z])
{
    return x+y+z;
};
let val3=fun2([1,2,3]);
console.log(val3);*/
//（4）提取JSON数据变得更加容易，的确如此，不仅仅是提取JSON，对于其它类似的文本也容易提取了。
//...
//（5）函数参数的默认值
//...
//（6）遍历Map解构
/*let map=new Map();
map.set("number1","Barry");
map.set("number2","Alex");
map.set("number3","Axure");
for(let [key] of map)
{
    console.log(key);
}*/
//（7）输入模块的指定方法，require模块或者是import时，就直接import {property1,...} from "./"...，而在js里就直接是const {property1,...}=require("module1");，这样我们就可以直接使用property1这个属性或者方法了
//字符串内置方法
// let aStr="hellold";
/*for(let char of aStr)
{
    console.log(char);
}*/
// console.log( aStr.charAt(1));
// console.log(aStr.includes("llo"));
// console.log(aStr.startsWith("as"));
// console.log(aStr.endsWith("ld"));
// console.log(aStr.repeat(2));
/**
 * Regular Expression Examples
 */
//Ep1:
// let pattern1=/pattern$/;
// let pattern2=new RegExp("pattern");
// console.log(pattern1.test("1000pattern"));
// console.log(pattern2.test("pattern"));
//Ep2:
// let speacialChars="[({})]\\^$.|?*+";
// let specialRExp=/\[\(\{\}\)\]\\\^\$\.\|\?\*\+/;//使用特殊字符时需要在前面加上转义字符反斜杠，这样才能和测试的字符串相匹配
// console.log(specialRExp.test(speacialChars));
//Ep3:验证字符串是否输入正确
// let phoneNumber="+86 400 800 8120";
// let isValidNum=phoneNumber.match(/^[\+\d\s]+$/);
// console.log(`${phoneNumber} is ${isValidNum ? 'valid':'INVALID'}`);
//学习Promise的传参
/*let promise1=new Promise((resolve,reject)=>{
    setTimeout(()=>{
        resolve("DeliveryParams");
        console.log("wait for one second.");
    },1000);
});

let promise2=new Promise((resolve,reject)=>{
    resolve(promise1);
});

let param;

let asyncFun=async function(){
    //resolve 返回的结果就是
    param = await promise1;
    console.log(param);
};

asyncFun();*/
//多参数
/*function add(...args:number[]):number{
    if(!args.length){
        return 0;
    }
    
    let sum:number=0;
    for(let item of args){
        sum+=item;
    }
    return sum;
}
console.log(add(1,2,3,4));*/
//解构对象再来一遍
/*let data=new GameData();
data.name="Barry";
let {name,golds}=new GameData();
console.log(name,golds);*/ 

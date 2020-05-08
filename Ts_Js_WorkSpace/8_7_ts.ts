//8_7_learning...

//#region 可索引接口，接口就相当于约束
interface CustomArray{
    [index:number]:string
}

let cb1=()=>{
    let array:CustomArray[]=["asdd","122"];
    console.log(array[0]);
}
//#endregion
//#region 对对象的约束接口，一般用不着，如果继承了这个接口那么对象属性的值就只能为string类型
interface CustomClass{
    [index:string]:string
}
let obj:CustomClass={name:"sda",property1:"213"};



//#endregion
//#region 抽象类
abstract class CustomAbstructClass {
    private _property: string;
    public get property(): string {
        return this._property;
    }
    public set property(value: string) {
        this._property = value;
    }
    constructor(val:string) {
        this._property=val;
    }
}

class ImplementClass1 extends CustomAbstructClass{

}

let ic:ImplementClass1=new ImplementClass1("");
//#endregion
//#region 对类的约束，接口
interface Animal{
    name:string,
    lifeSpan:number,
    move():void,
    bark():void
}

class Dog implements Animal{
    name: string;    
    lifeSpan: number;
    move(): void {

    }
    bark(): void {
        console.log(this.name)
    }
    constructor(name:string|void,lifeSpan:number|void){
        if(name){
            this.name=name;
        }else{
            this.name="a animal without name";
        }
        
        if(lifeSpan){
            this.lifeSpan=lifeSpan;
        }else{
            this.lifeSpan=1;
        }
    }    
}

let adog:Dog=new Dog();
adog.bark();
//#endregion
//#region 接口的扩展，接口继承其它的接口
interface Moyu{
    doNothing():void;
}

interface Person extends Animal{
    work():void;
}

class Programmer implements Person{
    work(): void {
        throw new Error("Method not implemented.");
    }    
    name: string;
    lifeSpan: number;
    move(): void {
        throw new Error("Method not implemented.");
    }
    bark(): void {
        throw new Error("Method not implemented.");
    }

    constructor(){
        this.name="Barry";
        this.lifeSpan=70;
    }
}

class GameProgrammer extends Programmer implements Moyu{
    doNothing(): void {
        console.log("摸鱼时间到~")
    }
}

//#endregion
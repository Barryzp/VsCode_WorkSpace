"use strict";
//8_7_learning...
let cb1 = () => {
    let array = ["asdd", "122"];
    console.log(array[0]);
};
let obj = { name: "sda", property1: "213" };
//#endregion
//#region 抽象类
class CustomAbstructClass {
    get property() {
        return this._property;
    }
    set property(value) {
        this._property = value;
    }
    constructor(val) {
        this._property = val;
    }
}
class ImplementClass1 extends CustomAbstructClass {
}
let ic = new ImplementClass1("");
class Dog {
    move() {
    }
    bark() {
        console.log(this.name);
    }
    constructor(name, lifeSpan) {
        if (name) {
            this.name = name;
        }
        else {
            this.name = "a animal without name";
        }
        if (lifeSpan) {
            this.lifeSpan = lifeSpan;
        }
        else {
            this.lifeSpan = 1;
        }
    }
}
let adog = new Dog();
adog.bark();
class Programmer {
    work() {
        throw new Error("Method not implemented.");
    }
    move() {
        throw new Error("Method not implemented.");
    }
    bark() {
        throw new Error("Method not implemented.");
    }
    constructor() {
        this.name = "Barry";
        this.lifeSpan = 70;
    }
}
class GameProgrammer extends Programmer {
    doNothing() {
        console.log("摸鱼时间到~");
    }
}
//#endregion

"use strict";
let temp = {
    x: 1,
    y: 2,
    success: () => {
        console.log("Successfully!");
    }
}

let tempSon = Object.create(temp);
tempSon.newItem = "asds";

for (let property in tempSon) {
    if (!tempSon.hasOwnProperty(property)) break;

    console.log(property)
    console.log(tempSon[property]);
}

console.log(Object.getPrototypeOf(tempSon));
console.log(tempSon.constructor.prototype);

console.log(Object.prototype.toString.call(tempSon).slice(8, -1));

console.log(temp.valueOf());

let b = {
    $a: 1, get A() {
        return this.a;
    }, set A(value) {
        this.a = value;
    }
}

Object.defineProperty(b, "a", { value: 12, writable: true })

console.log(b.A);

uniqueInteger.counter = 0;
function uniqueInteger() {
    return uniqueInteger.counter++;
}
console.log(uniqueInteger());

var scope="world scope";
let checkScope=()=>{
    var scope="local scope";
    return ()=>{
        return scope;
    }
}

console.log(checkScope()());//local scope

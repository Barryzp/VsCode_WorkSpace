"use strict";
let fun = (val, val2) => {
    return val + val2;
};
let fun2 = (val) => {
    return val;
};
console.log(fun2("sdasd"));
let fun3 = (val) => {
    return val * val;
};
let fun4 = (val) => {
    return val;
};
//还有这种骚操作来实现
let fun5 = fun4;
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
var A;
(function (A) {
    A[A["a"] = 1] = "a";
    A[A["b"] = 2] = "b";
})(A || (A = {}));
console.log(A[A.a]);
//#endregion

"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Observer_1 = require("./Observer");
class Emmiter {
    /**
     * 注册事件
     * @param name 事件名称
     * @param callback 回调函数
     * @param context 上下文
     */
    static Register(name, callback, context) {
        let observers = Emmiter.listener[name];
        if (!observers) {
            Emmiter.listener[name] = [];
        }
        Emmiter.listener[name].push(new Observer_1.Observer(callback, context));
    }
    /**
    * 移除事件
    * @param name 事件名称
    * @param callback 回调函数
    * @param context 上下文
    */
    static Remove(name, callback, context) {
        let observers = Emmiter.listener[name];
        if (!observers)
            return;
        let length = observers.length;
        for (let index = 0; index < length; index++) {
            let observer = observers[index];
            if (observer.Compare(context)) {
                observers.splice(index, 1);
                break;
            }
        }
        if (observers.length == 0) {
            delete Emmiter.listener[name];
        }
    }
    /**
     * 发送事件
     * @param name 事件名称
     */
    static Fire(name, ...args) {
        let observers = Emmiter.listener[name];
        if (!observers)
            return;
        let length = observers.length;
        for (let index = 0; index < length; index++) {
            let observer = observers[index];
            observer.Notify(...args);
        }
    }
}
Emmiter.listener = {};
exports.Emmiter = Emmiter;

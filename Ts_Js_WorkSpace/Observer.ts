export class Observer
{
    private callback:Function;
    private context:any=null;
    constructor(cb:Function,ct:any)
    {
        this.callback=cb;
        this.context=ct;
    }
    /**
     * 发送通知
     * @param args 不定参数
     */
    Notify(...args:any[]):void
    {
        let self=this;
        self.callback.call(self.context,...args);
    }

    /**
     * 上下文比较，即是事件响应方法所依赖的对象，也就是调用这个方法的对象。
     * @param context 上下文
     */
    Compare(context:any):boolean
    {
        return this.context==context;
    }
}
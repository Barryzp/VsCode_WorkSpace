import { Observer } from "./Observer";

export class Emmiter{
    private static listener={};
    /** 
     * 注册事件
     * @param name 事件名称
     * @param callback 回调函数
     * @param context 上下文
     */
     public static Register(name:string,callback:Function,context:any)
     {
        let observers:Observer[]=Emmiter.listener[name];
        if(!observers)
        {
           Emmiter.listener[name]=[];
        }
        Emmiter.listener[name].push(new Observer(callback,context));
     }

     /**
     * 移除事件
     * @param name 事件名称
     * @param callback 回调函数
     * @param context 上下文
     */
    public static Remove(name:string,callback:Function,context:any)
    {
       let observers:Observer[]=Emmiter.listener[name];
       if(!observers)return;

       let length=observers.length;
       for(let index=0;index<length;index++)
       {
         let observer=observers[index];
         if(observer.Compare(context))
         {
            observers.splice(index,1);
            break;
         }
       }

       if(observers.length==0)
       {
          delete Emmiter.listener[name];
       }
    }

    /**
     * 发送事件
     * @param name 事件名称
     */
    public static Fire(name:string,...args:any)
    {
      let observers:Observer[]=Emmiter.listener[name];
      if(!observers)return;
      let length=observers.length;
      for(let index=0;index<length;index++)
      {
         let observer=observers[index];
         observer.Notify(...args);
      }
    }
}
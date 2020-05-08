var netConfig =require('./netConfig')

var net = require('net');
var port=8848;

//createServer这个方法的参数如果是一个回调函数的话，那么
//一旦有客户端进行连接的话，就会被调用
var server = net.createServer(socket=>{
    let address=socket.address();
    console.log("客户端和服务器建立连接：%j",address);

    server.getConnections((err,count)=>{
        console.log("当前的连接数为:%d",count);
        server.maxConnections=netConfig.maxConnection;//可以进行设置最大连接
        console.log("最大连接数为:%d",server.maxConnections);
    });

    if(server.maxConnections>netConfig.maxConnection){
        server.close(err=>{
            console.log("连接数大于2，关闭服务器");
            if(err)console.log("关闭服务器失败:"+err);
            else console.log("关闭服务器成功");
        });
    }
});

server.listen(port,netConfig.localhost,()=>{
    console.log("服务器开始监听!");
});

server.on(netConfig.error,e=>{
    if(e.code==netConfig.EADDRINUSE){
        console.log("服务器地址或端口已被占用!");
    }
});

server.on(netConfig.close,()=>{
    console.log("服务器关闭喽~");
})

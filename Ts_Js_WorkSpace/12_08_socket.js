var fs=require('fs');
var netConfig=require('./netConfig');
var net=require('net');
var port=8848;

var writeStream=fs.createWriteStream('../test2.txt');
writeStream.on("pipe",()=>{
    console.log("写入数据中~");
})

var server=net.createServer();
server.on(netConfig.connection,socket=>{
    console.log("来了一个连接%j",socket.address());

    //HACK:这个写入流咋就写不进去呢？
    socket.pipe(writeStream,{end:false});
    socket.setEncoding("utf8");
    //这里的data实际上是一个Buffer对象，如果想要显示是普通字符则需要在前面设置编码，或者buffer.toString
    socket.on(netConfig.data,data=>{
        console.log(data);
        console.log("已接收的字节数:" +socket.bytesRead);
        //or data.toString();
    });
    socket.on(netConfig.end,()=>{
        console.log("客户端关闭~");
        writeStream.end("bye~");
        console.log(writeStream.bytesWritten);
    })
});

server.listen(port,netConfig.localhost,()=>{
    console.log("服务器开启监听~");
})

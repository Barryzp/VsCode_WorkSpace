var net=require('net');

var server=net.createServer();
server.on('connection',socket=>{
    console.log('收到一个客户端的连接~');
    socket.setEncoding('utf8');
    socket.on('data',data=>{
        console.log('收到一个客户端的数据：'+data);
        socket.write('确认数据：'+data);
    });
});

server.listen(8848,'127.0.0.1');
//服务端
var net=require('net');
var fs=require('fs');
var client=new net.Socket();
var writeStream=fs.createWriteStream('./temp.txt');

client.setEncoding('utf8');
client.connect(8848,'127.0.0.1',()=>{
    client.pipe(writeStream);
    console.log('已连接到服务端~');
    client.write('Hello server.');
});

client.on('data',data=>{
    console.log('已接收服务端的数据：'+data.toString());
    writeStream.write(data);
});

setTimeout(()=>{
    client.unpipe(writeStream);
    writeStream.end('over~');
},2000);
var fs = require('fs');

//#region 读取文件流
//表示从0个字节开始，一直读到第7个字节，包括第7个字节，所以数据长度是8
// let readStream=fs.createReadStream('./test.txt',{
//     start:0,
//     end:7
// })

/* 读取文件基本操作，（在读取文件流时一些基本事件触发）
// example1:

readStream.on('open',fd=>{
    console.log("start read file.");
})

//实际上读取的是一个流对象buffer，是从0开始的，一个汉字占3个字节（在UTF-8编码中）
readStream.on('data',data=>{
    console.log('got read data: '+data);
    console.log('data len: '+data.length);//8
})

readStream.on('end',()=>{
    console.log("file closed!");
})

readStream.on('error',err=>{
    console.log('read file failed.');
})
*/
// example2:

/*readStream.pause();

setTimeout(()=>{
    readStream.resume();
},1000);
*/
//#endregion

//#region 写入文件流
var file = fs.createReadStream('./test.txt');
var writeSream = fs.createWriteStream('./test2.txt');

//example1:写入流基本操作
/*file.on('data',data=>{
    writeSream.write(data,()=>{
        //同步在控制台上打印写入的内容
        console.log(data.toString());
    });
});

writeSream.on('open',fd=>{
    console.log("需要被写入的文件已被打开："+fd);
})

file.on('end',()=>{
    writeSream.end('再见',()=>{
        console.log("文件已经全部写入完毕~");
        console.log(`共写入${writeSream.bytesWritten}字节~`);
    });
})
*/

//example2:写入流，drain事件的监听（当操作系统缓存区中的数据已被全部读出并写入到目标文件时触发,之后可以继续向OS缓冲区写入新的数据）
//经过这一波测试之后drain事件到底何时才会被触发呢？只有当OS缓冲区满了，然后缓冲区的数据已经全部写入到目标文件，这个事件才会去触发，我们不用去关心缓冲区满了之后它是怎么写进去的操作
// for (let idx = 0; idx < 10000; idx++) {
//     console.log("是否可以向缓冲区里写入数据：" + writeSream.write(idx.toString()));
// }

// writeSream.on('drain', () => {
//     console.log("1系统缓存区中的数据已被全部读出并写入到目标文件");

//     var out = fs.createWriteStream('./test2.txt');
//     for (let idx = 0; idx < 10; idx++) {
//         console.log("是否可以向缓冲区里写入数据：" + out.write(idx.toString()));
//     }

//     out.on('drain', () => {
//         console.log("2系统缓存区中的数据已被全部读出并写入到目标文件");
//     })
// });

//一次性读取大文件测试，此时drain事件会触发很多次，原因就是缓冲区-填满-写入-填满。。。反反复复
// var mp3FileRs=fs.createReadStream('./1.mp3');
// var mp3FileWs=fs.createWriteStream('./2.mp3');

// mp3FileRs.on('data',data=>{
//     console.log("是否OS缓冲区没有写满："+mp3FileWs.write(data));
// });

// mp3FileWs.on('drain',()=>{
//     console.log("操作系统缓冲区的数据已全部输出~");
// });


//example3:pipe方法的使用
// file.pipe(writeSream,{end:false});
// file.on('end',()=>{
//     writeSream.end("farewell~");
//     file.unpipe(writeSream);
// });

//#endregion

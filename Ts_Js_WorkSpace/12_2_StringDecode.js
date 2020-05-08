var path = require('path');
var fs = require('fs');

let readFile_ts = () => {
    //读取文件方法
    fs.readFile('./test.txt', 'utf8', (err, data) => {
        //默认读取的数据是二进制Buffer，也可以修改为utf8
        if (err) console.log(err);
        else console.log(data);
    });

    //复制图片，采用base64编码的格式
    fs.readFile('./1.jpg', 'base64', (err, data) => {
        if (err) console.log("图片读取失败！errMsg: " + err);
        else fs.writeFile('./2.jpg', data.toString(), 'base64', err => {
            if (err) console.log("图片复制失败！errMsg:" + err)
            else console.log("图片复制成功！")
        })
    });
}

let appendFile_ts = () => {
    //追加文件
    fs.appendFile('./test.txt', '这是要追加的数据= _=', 'utf8', err => {
        if (err) console.log("追加文件失败！");
        else console.log("追加文件成功！");
    })
}

//从指定位置读取文件
let readPointFile=()=>{
    fs.open('./test.txt','r',(err,fd)=>{
        if(err)console.log("文件打开失败");
        else {
            console.log("文件打开成功,文件描述符: "+fd);
            var buff=Buffer.alloc(128);
            //一个汉字的utf编码为三个字节数据
            fs.read(fd,buff,0,9,6,(err,bytesRead,buffer)=>{
                console.log(buffer.toString());
                //打开文件事情干完之后养成关闭文件的好习惯
                fs.close(fd);
            })
        }
    })
}

//从指定位置写入数据
let writePointFile=()=>{
    var buff=Buffer.from("我喜欢yhl")
    //以追加模式打开文件
    fs.open('./test.txt','a',(err,fd)=>{
        if(err)console.log("文件打开失败");
        else {
            console.log("文件打开成功,文件描述符: "+fd);
            fs.write(fd,buff,0,12,0,(err,write,buffer)=>{
                if(err)console.log("写入文件失败");
                else console.log("写入文件成功");

                fs.close(fd,err=>{
                    if(err)console.log("关闭文件失败");
                    else console.log("关闭文件成功");
                })
            })
        }
    })
}

//文件的硬链接
let hardLink=()=>{
    fs.link('./test.txt','./test/test2.txt',(err)=>{
        if(err)console.log("硬链接创建失败!err:"+err);
        else console.log("硬链接创建成功!");
    })
};

//监视文件及文件夹的变动，注意，有多种功能，比如说还可以设置为某一段时间去监听，或者是只监听一次。或者是多种方法，比如说创建一个watch对象。
let watchFile=()=>{
    fs.watchFile('./test.txt',(cur,pre)=>{
        if(Date.parse(pre.ctime)==0)console.log("创建");
        if(Date.parse(cur.ctime)==0)console.log("删除");
        if(Date.parse(cur.ctime)!=Date.parse(pre.ctime))console.log("修改");
    });
}

let testPath=()=>{
    console.log(path.resolve("c"));
}

let pipeTest=()=>{
    var writeStream=fs.createWriteStream('./test2.txt');
    var readStream=fs.createReadStream('./test.txt');
    readStream.pipe(writeStream,{end:false});
};

pipeTest();
//#region let 和 var的使用
/*
let a=[];
for(let i=0;i<4;i++)
{
    a[i]=function()
    {
        console.log(i);
    }
}
a[2]();

let b=[];
for(var j=0;j<4;j++)
{
    b[j]=function()
    {
        console.log(j);
    }
}
b[0]();
b[2]();
*/
//#endregion

b=10;
{
    let b=20;
    console.log(b);
}

console.log(b);

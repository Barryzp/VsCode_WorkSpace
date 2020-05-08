var fs = require('fs');
var fileContent=`
    @ccclass
    export default class A extend cc.Component{

    }
`;

fs.readFile('./test1.ts',{
    flag:'w+'
} ,function (err,data) {
    if (err) {
        return console.log(err);
    }
    console.log("The file was saved!");
    console.log(__filename)
});


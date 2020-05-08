let timespan1=Date.now();
let strs="\"\asdas\"";
let regEx=/(['"])[^'"]*\1/;
console.log(strs.match(regEx));
let timespan2=Date.now();
console.log(timespan2-timespan1);
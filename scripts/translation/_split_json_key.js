// ref: https://stackoverflow.com/questions/39865991/javascript-how-to-split-key-with-dot-to-recovery-json-structure
const fs = require("fs");

var enPath = "translations/en.json";
var kmPath = "translations/km.json";
var zhRCNPath = "translations/zh-rCN.json";

var en = JSON.parse(fs.readFileSync(enPath, "utf8"));
var km = JSON.parse(fs.readFileSync(kmPath, "utf8"));
var zhRCN = JSON.parse(fs.readFileSync(zhRCNPath, "utf8"));

function splitJsonKey(obj, path) {
  Object.keys(obj).forEach(function (k) {
    var prop = k.split(".");
    var last = prop.pop();
    prop.reduce(function (o, key) {
      return (o[key] = o[key] || {});
    }, obj)[last] = obj[k];
    delete obj[k];
  });
  fs.writeFileSync(path, JSON.stringify(obj, null, 2), "utf-8");
}

splitJsonKey(en, enPath);
splitJsonKey(km, kmPath);
splitJsonKey(zhRCN, zhRCNPath);

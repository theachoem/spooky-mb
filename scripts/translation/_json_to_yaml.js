const jsyaml = require("js-yaml");
const fs = require("fs");

var enPath = "translations/en.json";
var kmPath = "translations/km.json";
var zhRCNPath = "translations/zh-rCN.json";

var en = JSON.parse(fs.readFileSync(enPath, "utf8"));
var km = JSON.parse(fs.readFileSync(kmPath, "utf8"));
var zhRCN = JSON.parse(fs.readFileSync(zhRCNPath, "utf8"));

function jsonToYaml(obj, path) {
  fs.unlink(path, (error) => {
    if (error) throw error;
    path = path.replace(".json", ".yaml");
    fs.writeFileSync(path, jsyaml.dump(obj), "utf-8");
  });
}

jsonToYaml(en, enPath);
jsonToYaml(km, kmPath);
jsonToYaml(zhRCN, zhRCNPath);

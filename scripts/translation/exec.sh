#!/bin/bash

echo -e "fetching data from spreadsheets..."
dart run scripts/translation/_load_json.dart

echo -e "\nspliting key with dot to recover json structure..."
node scripts/translation/_split_json_key.js

echo "done!"
exit

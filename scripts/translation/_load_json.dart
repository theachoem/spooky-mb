// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:dio/dio.dart';

const String appLocalization =
    'https://docs.google.com/spreadsheets/d/e/2PACX-1vSHYK3gxajB_9UsNB4XnUmQOZuhuNIJy4Mi-Iv5rh7RbX13mf7eOVkDjODwkBezKzd4EFtttwtSyC4z/pub?gid=0&single=true&output=csv';

void main() async {
  String endpoint = appLocalization;
  Response<dynamic> response = await Dio().get(endpoint);

  List<List<dynamic>> translations = const CsvToListConverter().convert(response.toString());
  Map translationsMap = {};

  for (List<dynamic> row in translations) {
    for (int i = 1; i < translations[0].length; i++) {
      translationsMap[translations[0][i]] ??= {};
      translationsMap[translations[0][i]][row[0]] ??= row[i];
    }
  }

  translationsMap.forEach((key, value) async {
    await _writeToFile(_filePath(key), value);
  });
}

String _filePath(String lang) {
  return "translations/$lang.json";
}

String _prettifyJson(Map<dynamic, dynamic> json) {
  JsonEncoder encoder = const JsonEncoder.withIndent("  ");
  String prettyJson = encoder.convert(json);
  return prettyJson;
}

Future<void> _writeToFile(String filePath, Map data) async {
  final file = File(filePath);
  await file.writeAsString(_prettifyJson(data)).then((File file) {
    // ignore: avoid_print
    print('$filePath created');
  });
}

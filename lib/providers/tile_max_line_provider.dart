import 'package:flutter/material.dart';
import 'package:spooky/core/storages/local_storages/tile_max_line_storage.dart';

class TileMaxLineProvider extends ChangeNotifier {
  final TileMaxLineStorage storage = TileMaxLineStorage();
  int maxLine = 5;

  TileMaxLineProvider() {
    load();
  }

  Future<void> load() async {
    maxLine = await storage.read() ?? 5;
    notifyListeners();
  }

  Future<void> setMaxLine(int? value) async {
    await storage.write(value);
    await load();
  }
}

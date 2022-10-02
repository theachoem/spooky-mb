import 'dart:io';
import 'package:spooky/providers/theme_provider.dart';
import 'package:spooky/theme/theme_constant.dart';
import 'package:spooky/utils/helpers/file_helper.dart';
import 'package:path/path.dart';

class GoogleFontCacheClearer {
  static void call() {
    List<FileSystemEntity> files = FileHelper.directory.listSync();
    String selectedFont = ThemeProvider.theme?.fontFamily ?? ThemeConstant.defaultFontFamily;
    for (FileSystemEntity file in files) {
      String path = basename(file.path);

      bool isTtf = path.endsWith(".ttf");
      bool notSelected = !path.startsWith(selectedFont.split(" ").first);

      bool unused = isTtf && notSelected;
      if (unused) file.deleteSync();
    }
  }
}

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:spooky/main.dart';
import 'package:path/path.dart';

class FileHelper {
  static Directory get directory => _directory!;
  static Directory? _directory;

  static Directory get supportDirectory => _supportDirectory!;
  static Directory? _supportDirectory;

  static Future<void> initialFile() async {
    if (spFlutterTest) {
      _directory = Directory.current;
      _supportDirectory = Directory.current;
    } else {
      _directory = await getApplicationDocumentsDirectory();
      _supportDirectory = await getApplicationSupportDirectory();
    }
  }

  static String fileName(String path) {
    return basename(path);
  }

  static String removeDirectory(String path) {
    return path.replaceFirst(directory.path, "").replaceFirst("/", "");
  }

  static String addDirectory(String path) {
    return directory.path + "/" + path;
  }
}

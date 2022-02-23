import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:spooky/main.dart';
import 'package:path/path.dart';

class FileHelper {
  static Directory get directory => _directory!;
  static Directory? _directory;

  static Directory get exposedDirectory => _exposedDirectory!;
  static Directory? _exposedDirectory;

  static Future<void> initialFile() async {
    if (spFlutterTest) {
      _exposedDirectory = Directory.current;
      _directory = Directory.current;
    } else {
      _directory = await getApplicationSupportDirectory();
      if (Platform.isAndroid) {
        _exposedDirectory = await getExternalStorageDirectory();
      } else {
        _exposedDirectory = await getApplicationDocumentsDirectory();
      }
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

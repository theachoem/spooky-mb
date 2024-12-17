import 'package:spooky_mb/core/services/file_service.dart';

class FileInitializer {
  static Future<void> call() async {
    await FileService.initialFile();
  }
}

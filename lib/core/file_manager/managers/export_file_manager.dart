import 'dart:io';
import 'package:spooky/core/file_manager/base/base_file_manager.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

class ExportFileManager extends BaseFileManager {
  Future<File?> exportFile(File file) async {
    String exportDestination = file.path.replaceFirst(FileHelper.directory.path, FileHelper.exposedDirectory.path);
    return copy(file, exportDestination);
  }

  FileSystemEntity? hasExported(File? file) {
    if (file == null) return null;
    Iterable<FileSystemEntity> files = FileHelper.exposedDirectory
        .listSync(recursive: true)
        .where((element) => element.path.endsWith(FileHelper.fileName(file.path)));
    return files.isNotEmpty ? files.first : null;
  }

  String displayPath(FileSystemEntity file) {
    if (Platform.isAndroid) {
      return file.path;
    } else {
      return file.path.replaceFirst(
        (FileHelper.exposedDirectory.path.split("/")..removeLast()).join("/"),
        "~",
      );
    }
  }
}

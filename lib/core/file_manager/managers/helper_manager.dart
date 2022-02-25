import 'dart:io';

import 'package:spooky/core/file_manager/base/base_file_manager.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

class HelpManager extends BaseFileManager {
  Directory get root => FileHelper.directory;
}

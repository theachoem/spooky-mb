import 'package:spooky/core/models/cloud_file_model.dart';

class CloudFileListModel {
  final List<CloudFileModel> files;
  final String? nextToken;

  CloudFileListModel({
    required this.files,
    this.nextToken,
  });
}

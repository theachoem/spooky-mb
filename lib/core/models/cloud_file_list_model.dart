import 'package:spooky/core/models/cloud_file_model.dart';

class CloudFileListModel {
  final List<CloudFileModel> files;
  final String? nextToken;

  CloudFileListModel({
    required this.files,
    this.nextToken,
  });

  CloudFileListModel copyWith({
    List<CloudFileModel>? files,
  }) {
    return CloudFileListModel(
      files: files ?? this.files,
      nextToken: nextToken,
    );
  }
}

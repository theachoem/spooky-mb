import 'package:spooky/core/backups/models/backups_metadata.dart';
import 'package:spooky/core/models/cloud_file_model.dart';

class CloudFileTuple {
  final CloudFileModel cloudFile;
  final BackupsMetadata metadata;

  CloudFileTuple({
    required this.cloudFile,
    required this.metadata,
  });
}

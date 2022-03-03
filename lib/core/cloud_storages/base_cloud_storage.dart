import 'package:spooky/core/models/cloud_file_list_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';

abstract class BaseCloudStorage {
  Future<T?> execHandler<T>(Future<T?> Function() request);
  Future<CloudFileModel?> exist(Map<String, dynamic> options);
  Future<CloudFileModel?> write(Map<String, dynamic> options);
  Future<CloudFileModel?> delete(Map<String, dynamic> options);
  Future<bool> synced(Map<String, dynamic> options);
  Future<CloudFileListModel?> list(Map<String, dynamic> options);
}

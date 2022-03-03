import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/cloud_storages/base_cloud_storage.dart';
import 'package:spooky/core/cloud_storages/gdrive_storage.dart';
import 'package:spooky/core/models/cloud_file_list_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';

class CloudStorageViewModel extends BaseViewModel {
  BaseCloudStorage cloudStorage = GDriveStorage();
  CloudFileListModel? files;

  CloudStorageViewModel() {
    load();
  }

  Future<void> load() async {
    CloudFileListModel? result = await cloudStorage.execHandler(() async {
      return cloudStorage.list({
        "next_token": files?.nextToken,
      });
    });
    files = result;
    notifyListeners();
  }

  Future<void> delete(CloudFileModel file) async {
    await cloudStorage.execHandler(() async {
      return cloudStorage.delete({'file_id': file.id});
    });
    await load();
  }
}

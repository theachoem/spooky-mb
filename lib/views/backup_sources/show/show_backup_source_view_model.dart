import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/objects/cloud_file_list_object.dart';
import 'package:spooky/core/objects/cloud_file_object.dart';
import 'show_backup_source_view.dart';

class ShowBackupSourceViewModel extends BaseViewModel {
  final ShowBackupSourceRoute params;

  ShowBackupSourceViewModel({
    required this.params,
  }) {
    load();
  }

  CloudFileListObject? get cloudFiles => _cloudFiles;
  CloudFileListObject? _cloudFiles;

  bool _disabledActions = true;
  bool get disabledActions => _disabledActions;

  Future<void> load() async {
    _cloudFiles = await params.source.fetchAllCloudFiles();
    _disabledActions = false;
    notifyListeners();
  }

  Future<void> delete(CloudFileObject file) async {
    _disabledActions = true;
    notifyListeners();

    await params.source.deleteCloudFile(file);
    await load();
  }
}

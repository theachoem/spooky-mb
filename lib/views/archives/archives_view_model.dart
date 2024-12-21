import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/types/path_type.dart';

class ArchivesViewModel extends BaseViewModel {
  PathType type = PathType.archives;

  void setType(PathType type) {
    this.type = type;
    notifyListeners();
  }
}

import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/types/path_type.dart';

class ArchiveViewModel extends BaseViewModel {
  final List<PathType> pathTypes = [
    PathType.archives,
    PathType.bins,
  ];

  PathType _selectedPathType = PathType.archives;
  PathType get selectedPathType => _selectedPathType;

  void setPathType(PathType value) {
    if (value == selectedPathType) return;
    _selectedPathType = value;
    notifyListeners();
  }
}

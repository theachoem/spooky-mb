import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/services/story_helper.dart';
import 'package:spooky/views/stories/changes/show/show_change_view.dart';

class ShowChangeViewModel extends BaseViewModel {
  final ShowChangeView params;

  ShowChangeViewModel({
    required this.params,
  }) {
    load();
  }

  Map<int, QuillController>? quillControllers;

  Future<void> load() async {
    quillControllers = await StoryHelper.buildQuillControllers(params.content, readOnly: true);
    notifyListeners();
  }

  @override
  void dispose() {
    quillControllers?.forEach((e, k) => k.dispose());
    super.dispose();
  }
}

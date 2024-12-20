import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_quill_toolbar_color_button.dart';
import 'package:spooky/widgets/sp_fade_in.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'page_editor_view_model.dart';

part 'page_editor_adaptive.dart';
part './local_widgets/editor.dart';

class PageEditorView extends StatelessWidget {
  const PageEditorView({
    super.key,
    this.storyId,
    this.initialPageIndex = 0,
    this.quillControllers,
  });

  final int? storyId;
  final int initialPageIndex;
  final Map<int, QuillController>? quillControllers;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<PageEditorViewModel>(
      create: (context) => PageEditorViewModel(params: this),
      builder: (context, viewModel, child) {
        return _PageEditorAdaptive(viewModel);
      },
    );
  }
}

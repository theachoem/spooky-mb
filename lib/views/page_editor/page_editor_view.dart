import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky_mb/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';

import 'page_editor_view_model.dart';

part 'page_editor_adaptive.dart';

class PageEditorView extends StatelessWidget {
  const PageEditorView({
    super.key,
    required this.initialDocument,
    required this.initialTextSelection,
  });

  final List<dynamic>? initialDocument;
  final TextSelection? initialTextSelection;

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

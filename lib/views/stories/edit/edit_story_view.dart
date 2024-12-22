import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_quill_toolbar_color_button.dart';
import 'package:spooky/widgets/sp_fade_in.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';

import 'edit_story_view_model.dart';

part 'edit_story_adaptive.dart';
part 'local_widgets/editor.dart';

class EditStoryView extends StatelessWidget {
  const EditStoryView({
    super.key,
    this.id,
    this.initialYear,
    this.initialPageIndex = 0,
    this.quillControllers,
  }) : assert(initialYear == null || id == null);

  final int? id;
  final int? initialYear;
  final int initialPageIndex;
  final Map<int, QuillController>? quillControllers;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<EditStoryViewModel>(
      create: (context) => EditStoryViewModel(params: this),
      builder: (context, viewModel, child) {
        return _EditStoryAdaptive(viewModel);
      },
    );
  }
}

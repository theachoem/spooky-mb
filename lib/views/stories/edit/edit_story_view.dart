import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/services/date_format_service.dart';
import 'package:spooky/routes/base_route.dart';
import 'package:spooky/views/stories/local_widgets/story_title.dart';
import 'package:spooky/views/stories/local_widgets/tags_end_drawer.dart';
import 'package:spooky/widgets/sp_feeling_picker/sp_feeling_button.dart';
import 'package:spooky/widgets/sp_quill_toolbar_color_button.dart';
import 'package:spooky/widgets/sp_fade_in.dart';

import 'edit_story_view_model.dart';

part 'edit_story_adaptive.dart';
part 'local_widgets/editor.dart';

class EditStoryRoute extends BaseRoute {
  final int? id;
  final int? initialYear;
  final int initialPageIndex;
  final Map<int, QuillController>? quillControllers;
  final StoryDbModel? story;

  EditStoryRoute({
    this.id,
    this.initialYear,
    this.initialPageIndex = 0,
    this.quillControllers,
    this.story,
  }) : assert(initialYear == null || id == null);

  @override
  Widget buildPage(BuildContext context) => EditStoryView(params: this);
}

class EditStoryView extends StatelessWidget {
  const EditStoryView({
    super.key,
    required this.params,
  });

  final EditStoryRoute params;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<EditStoryViewModel>(
      create: (context) => EditStoryViewModel(params: params),
      builder: (context, viewModel, child) {
        return _EditStoryAdaptive(viewModel);
      },
    );
  }
}

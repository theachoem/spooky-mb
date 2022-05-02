library content_reader_view;

import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/views/content_reader/local_widgets/content_page_viewer.dart';
import 'package:spooky/views/detail/local_widgets/page_indicator_button.dart';
import 'package:spooky/widgets/sp_page_view/sp_page_view.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'content_reader_view_model.dart';

part 'content_reader_mobile.dart';
part 'content_reader_tablet.dart';
part 'content_reader_desktop.dart';

class ContentReaderView extends StatelessWidget {
  const ContentReaderView({
    Key? key,
    required this.content,
  }) : super(key: key);

  final StoryContentDbModel content;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ContentReaderViewModel>(
      create: (BuildContext context) => ContentReaderViewModel(content),
      builder: (context, viewModel, child) {
        return SpScreenTypeLayout(
          mobile: _ContentReaderMobile(viewModel),
          desktop: _ContentReaderDesktop(viewModel),
          tablet: _ContentReaderTablet(viewModel),
        );
      },
    );
  }
}

library content_reader_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/ui/views/content_reader/local_widgets/content_page_viewer.dart';
import 'package:spooky/ui/views/detail/local_widgets/content_indicator.dart';
import 'package:spooky/ui/widgets/sp_pop_button.dart';
import 'package:stacked/stacked.dart';
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

  final StoryContentModel content;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ContentReaderViewModel>.reactive(
      viewModelBuilder: () => ContentReaderViewModel(content),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return ScreenTypeLayout(
          mobile: _ContentReaderMobile(model),
          desktop: _ContentReaderDesktop(model),
          tablet: _ContentReaderTablet(model),
        );
      },
    );
  }
}

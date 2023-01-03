import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/story_config_provider.dart';
import 'package:spooky/widgets/sp_story_list/sp_story_list.dart';

typedef SpListLayoutBuilderTypedef = Widget Function(BuildContext context, SpListLayoutType type, bool loaded);

class SpListLayoutBuilder extends StatelessWidget {
  const SpListLayoutBuilder({
    Key? key,
    required this.builder,
    this.overridedLayout,
  }) : super(key: key);

  final SpListLayoutBuilderTypedef builder;
  final SpListLayoutType? overridedLayout;

  @override
  Widget build(BuildContext context) {
    final StoryConfigProvider provider = context.read<StoryConfigProvider>();
    return ValueListenableBuilder<SpListLayoutType?>(
      valueListenable: provider.layoutTypeNotifier,
      builder: (context, layoutType, _) {
        return builder(
          context,
          overridedLayout ?? layoutType ?? provider.storage.layoutType,
          layoutType != null,
        );
      },
    );
  }
}

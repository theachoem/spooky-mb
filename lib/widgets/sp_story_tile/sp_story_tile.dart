library sp_story_tile;

import 'package:flutter/material.dart';
import 'package:spooky/core/db/models/story_db_model.dart';

part 'contents/base_tile_content.dart';
part 'contents/grid_item_content.dart';
part 'contents/list_item_content.dart';

class SpStoryTile extends StatelessWidget {
  const SpStoryTile({
    Key? key,
    required this.story,
    required this.gridLayout,
  }) : super(key: key);

  final bool gridLayout;
  final StoryDbModel story;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildTileContent(),
    );
  }

  Widget buildTileContent() {
    if (gridLayout) {
      return _GridItemContent();
    } else {
      return _ListStoryTileContent();
    }
  }
}

part of sp_story_list;

enum SpListLayoutType {
  /// mutlple list with tab of tags
  library,

  /// mutlple list with tab of month
  diary,

  /// single list display, no tab
  timeline,
}

extension SpListLayoutTypeExtension on SpListLayoutType {
  IconData get icon {
    switch (this) {
      case SpListLayoutType.library:
        return Icons.grid_view_rounded;
      case SpListLayoutType.diary:
        return Icons.view_day;
      case SpListLayoutType.timeline:
        return Icons.view_list_sharp;
    }
  }

  SpListLayoutType get next {
    switch (this) {
      case SpListLayoutType.library:
        return SpListLayoutType.timeline;
      case SpListLayoutType.diary:
        return SpListLayoutType.library;
      case SpListLayoutType.timeline:
        return SpListLayoutType.library;
    }
  }
}

import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum SortType {
  newToOld,
  oldToNew,
}

extension SpListSortTypeExtension on SortType {
  IconData get icon {
    switch (this) {
      case SortType.newToOld:
        return CommunityMaterialIcons.sort_calendar_ascending;
      case SortType.oldToNew:
        return CommunityMaterialIcons.sort_calendar_descending;
    }
  }

  String get title {
    switch (this) {
      case SortType.oldToNew:
        return tr("tile.sort.types.old_to_new");
      case SortType.newToOld:
        return tr("tile.sort.types.new_to_old");
    }
  }

  SortType get next {
    switch (this) {
      case SortType.newToOld:
        return SortType.oldToNew;
      case SortType.oldToNew:
        return SortType.newToOld;
    }
  }
}

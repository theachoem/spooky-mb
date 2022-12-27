part of '../home_view_model.dart';

class HomeTabItem {
  final int id;
  final String label;
  final TagDbModel? tag;
  final SpListLayoutType? overridedLayout;

  HomeTabItem(
    this.id,
    this.label,
    this.tag,
    this.overridedLayout,
  );

  factory HomeTabItem.fromTag(TagDbModel tag) {
    return HomeTabItem(tag.id, tag.title, tag, null);
  }

  factory HomeTabItem.fromIndexToMonth(int index) {
    final int monthIndex = index + 1;
    final String monthName = DateFormatHelper.toNameOfMonth().format(DateTime(1999, monthIndex));
    return HomeTabItem(index + 1, monthName, null, null);
  }

  HomeTabItem copyWith({
    int? id,
    String? label,
    TagDbModel? tag,
    SpListLayoutType? overridedLayout,
  }) {
    return HomeTabItem(
      id ?? this.id,
      label ?? this.label,
      tag ?? this.tag,
      overridedLayout ?? this.overridedLayout,
    );
  }
}

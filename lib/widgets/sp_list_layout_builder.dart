import 'package:flutter/material.dart';
import 'package:spooky/core/storages/local_storages/sp_list_layout_type_storage.dart';
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

  static SpListLayoutTypeStorage get storage => SpListLayoutTypeStorage();
  static SpListLayoutType get defaultLayout => SpListLayoutType.diary;

  static Future<SpListLayoutType> get() async {
    return await storage.readEnum() ?? defaultLayout;
  }

  static Future<void> set(SpListLayoutType type) async {
    return await storage.writeEnum(type);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SpListLayoutType>(
      future: get(),
      builder: (context, snapshot) {
        return builder(
          context,
          overridedLayout ?? snapshot.data ?? defaultLayout,
          snapshot.hasData,
        );
      },
    );
  }
}

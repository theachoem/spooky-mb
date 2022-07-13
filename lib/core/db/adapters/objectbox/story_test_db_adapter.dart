// ignore_for_file: body_might_complete_normally_nullable

part of 'package:spooky/core/db/databases/story_database.dart';

class _StoryTestDbAdapter extends BaseDbAdapter<StoryDbModel> with BaseStoryDbExternalActions {
  _StoryTestDbAdapter(String tableName) : super(tableName);

  @override
  Future<StoryDbModel?> create({
    required StoryDbModel body,
    Map<String, dynamic> params = const {},
  }) async {}

  @override
  Future<StoryDbModel?> delete({
    required int id,
    Map<String, dynamic> params = const {},
  }) async {}

  @override
  Future<BaseDbListModel<StoryDbModel>?> fetchAll({
    Map<String, dynamic>? params,
  }) async {
    // {
    //   "data": List.generate(10, (index) {
    //     return StoryDbModel.fromNow();
    //   }).map((e) => e.toJson()).toList(),
    //   "meta": MetaModel().toJson(),
    //   "links": LinksModel().toJson(),
    // };
    return BaseDbListModel(
      items: List.generate(10, (index) {
        return StoryDbModel.fromNow();
      }).toList(),
      meta: MetaModel(),
      links: LinksModel(),
    );
  }

  @override
  Future<StoryDbModel?> fetchOne({
    required int id,
    Map<String, dynamic>? params,
  }) async {}

  @override
  Future<Set<int>?> fetchYears() async {}

  @override
  int getDocsCount(int? year) {
    return 0;
  }

  @override
  Future<StoryDbModel?> set({
    required StoryDbModel body,
    Map<String, dynamic> params = const {},
  }) async {}

  @override
  Future<StoryDbModel?> update({
    required int id,
    required StoryDbModel body,
    Map<String, dynamic> params = const {},
  }) async {}
}

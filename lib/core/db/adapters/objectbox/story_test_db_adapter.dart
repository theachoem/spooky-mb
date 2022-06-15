// ignore_for_file: body_might_complete_normally_nullable

part of 'package:spooky/core/db/databases/story_database.dart';

class _StoryTestDbAdapter extends BaseDbAdapter with BaseStoryDbExternalActions {
  _StoryTestDbAdapter(String tableName) : super(tableName);

  @override
  Future<Map<String, dynamic>?> create({
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {}

  @override
  Future<Map<String, dynamic>?> delete({
    required int id,
    Map<String, dynamic> params = const {},
  }) async {}

  @override
  Future<Map<String, dynamic>?> fetchAll({
    Map<String, dynamic>? params,
  }) async {
    return {
      "data": List.generate(10, (index) {
        return StoryDbModel.fromNow();
      }).map((e) => e.toJson()).toList(),
      "meta": MetaModel().toJson(),
      "links": MetaModel().toJson(),
    };
  }

  @override
  Future<Map<String, dynamic>?> fetchOne({
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
  Future<Map<String, dynamic>?> set({
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {}

  @override
  Future<Map<String, dynamic>?> update({
    required int id,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {}
}

part of '../../databases/story_database.dart';

class _StoryObjectBoxDbAdapter extends BaseObjectBoxAdapter<StoryObjectBox_> {
  _StoryObjectBoxDbAdapter(String tableName) : super(tableName);

  @override
  Future<Map<String, dynamic>?> create({
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> delete({
    required int id,
    Map<String, dynamic> params = const {},
  }) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> fetchAll({
    Map<String, dynamic>? params,
  }) {
    // TODO: implement fetchAll
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> fetchOne({
    required int id,
    Map<String, dynamic>? params,
  }) {
    // TODO: implement fetchOne
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> update({
    required int id,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) {
    // TODO: implement update
    throw UnimplementedError();
  }
}

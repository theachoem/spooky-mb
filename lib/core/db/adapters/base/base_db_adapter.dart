abstract class BaseDbAdapter {
  final String tableName;
  BaseDbAdapter(this.tableName);

  Future<Map<String, dynamic>?> fetchAll({
    Map<String, dynamic>? params,
  });

  Future<Map<String, dynamic>?> fetchOne({
    required String id,
    Map<String, dynamic>? params,
  });

  Future<Map<String, dynamic>?> create({
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  });

  Future<Map<String, dynamic>?> update({
    required String id,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  });

  Future<Map<String, dynamic>?> delete({
    required String id,
    Map<String, dynamic> params = const {},
  });
}

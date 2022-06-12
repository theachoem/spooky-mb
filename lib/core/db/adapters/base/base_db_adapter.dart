abstract class BaseDbAdapter {
  final String tableName;
  BaseDbAdapter(this.tableName);

  Future<Map<String, dynamic>?> fetchAll({
    Map<String, dynamic>? params,
  });

  Future<Map<String, dynamic>?> fetchOne({
    required int id,
    Map<String, dynamic>? params,
  });

  Future<Map<String, dynamic>?> create({
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  });

  Future<Map<String, dynamic>?> update({
    required int id,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  });

  Future<Map<String, dynamic>?> delete({
    required int id,
    Map<String, dynamic> params = const {},
  });
}

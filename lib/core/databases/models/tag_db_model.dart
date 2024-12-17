import 'package:spooky_mb/core/databases/adapters/base_db_adapter.dart';
import 'package:spooky_mb/core/databases/models/base_db_model.dart';

class TagDbModel extends BaseDbModel {
  @override
  BaseDbAdapter<BaseDbModel> get dbAdapter => throw UnimplementedError();

  final int id;
  final int index;
  final int version;
  final String title;
  final bool? starred;
  final String? emoji;
  final DateTime createdAt;
  final DateTime updatedAt;

  TagDbModel({
    required this.id,
    required this.version,
    required this.title,
    required this.starred,
    required this.emoji,
    required this.createdAt,
    required this.updatedAt,
    int? index,
  }) : index = index ?? 0;

  TagDbModel.fromIDTitle(this.id, this.title)
      : version = 0,
        starred = null,
        emoji = null,
        index = 0,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();
}

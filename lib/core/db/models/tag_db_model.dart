import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';

part 'tag_db_model.g.dart';

@JsonSerializable()
@CopyWith()
class TagDbModel extends BaseDbModel {
  final int id;
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
  });

  @override
  Map<String, dynamic> toJson() => _$TagDbModelToJson(this);
  factory TagDbModel.fromJson(Map<String, dynamic> json) => _$TagDbModelFromJson(json);
}

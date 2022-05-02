import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/models/base_model.dart';

part 'backup_model.g.dart';

@JsonSerializable()
class BackupModel extends BaseModel {
  final int? version;
  final int year;
  final DateTime createdAt;
  final List<StoryDbModel> stories;

  BackupModel({
    this.version = 1,
    required this.year,
    required this.createdAt,
    required this.stories,
  });

  // 2022_2022-03-05T02:30:57.218875.json
  String get fileName {
    return "$year" "_" "${createdAt.toIso8601String()}" ".json";
  }

  @override
  Map<String, dynamic> toJson() => _$BackupModelToJson(this);
  factory BackupModel.fromJson(Map<String, dynamic> json) => _$BackupModelFromJson(json);

  @override
  String? get objectId => fileName;
}

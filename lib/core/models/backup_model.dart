import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/story_model.dart';

part 'backup_model.g.dart';

@JsonSerializable()
class BackupModel {
  final int year;
  final DateTime createdAt;
  final List<StoryModel> stories;

  BackupModel({
    required this.year,
    required this.createdAt,
    required this.stories,
  });

  // 2020_1646123928000.json
  String get fileName {
    return "$year" "_" "${createdAt.millisecondsSinceEpoch}" ".json";
  }

  Map<String, dynamic> toJson() => _$BackupModelToJson(this);
  factory BackupModel.fromJson(Map<String, dynamic> json) => _$BackupModelFromJson(json);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/db/base_models/base_db_model.dart';

part 'story_db_model.g.dart';

@JsonSerializable()
class StoryDbModel extends BaseDbModel {
  final int? id;

  StoryDbModel({
    this.id,
  });

  @override
  Map<String, dynamic> toJson() => _$StoryDbModelToJson(this);
  factory StoryDbModel.fromJson(Map<String, dynamic> json) => _$StoryDbModelFromJson(json);
}

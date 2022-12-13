import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';

part 'category_db_model.g.dart';

@JsonSerializable()
@CopyWith()
class CategoryDbModel extends BaseDbModel {
  int id;
  int position;
  String type;
  String name;
  double? budget;
  String? icon;
  DateTime createdAt;
  DateTime? updatedAt;

  CategoryDbModel({
    required this.id,
    required this.position,
    required this.type,
    required this.name,
    required this.budget,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  Map<String, dynamic> toJson() => _$CategoryDbModelToJson(this);
  factory CategoryDbModel.fromJson(Map<String, dynamic> json) => _$CategoryDbModelFromJson(json);
}

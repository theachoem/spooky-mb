import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/base_model.dart';

part 'author_model.g.dart';

@CopyWith()
@JsonSerializable()
class AuthorModel extends BaseModel {
  AuthorModel({
    this.type,
    this.id,
    this.name,
    this.age,
    this.gender,
  });

  final String? type;
  final String? id;
  final String? name;
  final int? age;
  final String? gender;

  @override
  Map<String, dynamic> toJson() => _$AuthorModelToJson(this);
  factory AuthorModel.fromJson(Map<String, dynamic> json) => _$AuthorModelFromJson(json);

  @override
  String? get objectId => id;
}

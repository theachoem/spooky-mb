import 'package:json_annotation/json_annotation.dart';

part 'meta_db_model.g.dart';

@JsonSerializable()
class MetaDbModel {
  final int? count;
  final int? totalCount;
  final int? totalPages;
  final int? currentPage;

  MetaDbModel({
    this.count,
    this.totalCount,
    this.totalPages,
    this.currentPage,
  });

  Map<String, dynamic> toJson() => _$MetaDbModelToJson(this);
  factory MetaDbModel.fromJson(Map<String, dynamic> json) => _$MetaDbModelFromJson(json);
}

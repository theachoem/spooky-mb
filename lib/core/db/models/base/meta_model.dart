import 'package:json_annotation/json_annotation.dart';

part 'meta_model.g.dart';

@JsonSerializable()
class MetaModel {
  final int? count;
  final int? totalCount;
  final int? totalPages;
  final int? currentPage;

  MetaModel({
    this.count,
    this.totalCount,
    this.totalPages,
    this.currentPage,
  });

  Map<String, dynamic> toJson() => _$MetaModelToJson(this);
  factory MetaModel.fromJson(Map<String, dynamic> json) => _$MetaModelFromJson(json);
}

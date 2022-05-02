import 'package:json_annotation/json_annotation.dart';

part 'links_model.g.dart';

@JsonSerializable()
class LinksModel {
  final int? self;
  final int? next;
  final int? prev;
  final int? last;

  LinksModel({
    this.self,
    this.next,
    this.prev,
    this.last,
  });

  Map<String, dynamic> toJson() => _$LinksModelToJson(this);
  factory LinksModel.fromJson(Map<String, dynamic> json) => _$LinksModelFromJson(json);
}

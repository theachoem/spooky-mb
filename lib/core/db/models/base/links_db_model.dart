import 'package:json_annotation/json_annotation.dart';

part 'links_db_model.g.dart';

@JsonSerializable()
class LinksDbModel {
  final int? self;
  final int? next;
  final int? prev;
  final int? last;

  LinksDbModel({
    this.self,
    this.next,
    this.prev,
    this.last,
  });

  Map<String, dynamic> toJson() => _$LinksDbModelToJson(this);
  factory LinksDbModel.fromJson(Map<String, dynamic> json) => _$LinksDbModelFromJson(json);
}

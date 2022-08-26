// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'links_db_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinksDbModel _$LinksDbModelFromJson(Map<String, dynamic> json) => LinksDbModel(
      self: json['self'] as int?,
      next: json['next'] as int?,
      prev: json['prev'] as int?,
      last: json['last'] as int?,
    );

Map<String, dynamic> _$LinksDbModelToJson(LinksDbModel instance) =>
    <String, dynamic>{
      'self': instance.self,
      'next': instance.next,
      'prev': instance.prev,
      'last': instance.last,
    };

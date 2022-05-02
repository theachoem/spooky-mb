// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'links_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinksModel _$LinksModelFromJson(Map<String, dynamic> json) => LinksModel(
      self: json['self'] as int?,
      next: json['next'] as int?,
      prev: json['prev'] as int?,
      last: json['last'] as int?,
    );

Map<String, dynamic> _$LinksModelToJson(LinksModel instance) =>
    <String, dynamic>{
      'self': instance.self,
      'next': instance.next,
      'prev': instance.prev,
      'last': instance.last,
    };

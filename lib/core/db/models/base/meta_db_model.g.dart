// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_db_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaDbModel _$MetaDbModelFromJson(Map<String, dynamic> json) => MetaDbModel(
      count: json['count'] as int?,
      totalCount: json['total_count'] as int?,
      totalPages: json['total_pages'] as int?,
      currentPage: json['current_page'] as int?,
    );

Map<String, dynamic> _$MetaDbModelToJson(MetaDbModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'total_count': instance.totalCount,
      'total_pages': instance.totalPages,
      'current_page': instance.currentPage,
    };

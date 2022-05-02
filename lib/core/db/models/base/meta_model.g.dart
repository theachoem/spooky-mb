// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaModel _$MetaModelFromJson(Map<String, dynamic> json) => MetaModel(
      count: json['count'] as int?,
      totalCount: json['total_count'] as int?,
      totalPages: json['total_pages'] as int?,
      currentPage: json['current_page'] as int?,
    );

Map<String, dynamic> _$MetaModelToJson(MetaModel instance) => <String, dynamic>{
      'count': instance.count,
      'total_count': instance.totalCount,
      'total_pages': instance.totalPages,
      'current_page': instance.currentPage,
    };

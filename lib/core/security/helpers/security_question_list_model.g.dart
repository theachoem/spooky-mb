// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_question_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecurityQuestionListModel _$SecurityQuestionListModelFromJson(
        Map<String, dynamic> json) =>
    SecurityQuestionListModel(
      (json['items'] as List<dynamic>?)
          ?.map(
              (e) => SecurityQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SecurityQuestionListModelToJson(
        SecurityQuestionListModel instance) =>
    <String, dynamic>{
      'items': instance.items?.map((e) => e.toJson()).toList(),
    };

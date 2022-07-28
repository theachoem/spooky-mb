// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_question_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SecurityQuestionModelCWProxy {
  SecurityQuestionModel answer(String? answer);

  SecurityQuestionModel key(String key);

  SecurityQuestionModel question(String question);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SecurityQuestionModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SecurityQuestionModel(...).copyWith(id: 12, name: "My name")
  /// ````
  SecurityQuestionModel call({
    String? answer,
    String? key,
    String? question,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSecurityQuestionModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSecurityQuestionModel.copyWith.fieldName(...)`
class _$SecurityQuestionModelCWProxyImpl
    implements _$SecurityQuestionModelCWProxy {
  final SecurityQuestionModel _value;

  const _$SecurityQuestionModelCWProxyImpl(this._value);

  @override
  SecurityQuestionModel answer(String? answer) => this(answer: answer);

  @override
  SecurityQuestionModel key(String key) => this(key: key);

  @override
  SecurityQuestionModel question(String question) => this(question: question);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SecurityQuestionModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SecurityQuestionModel(...).copyWith(id: 12, name: "My name")
  /// ````
  SecurityQuestionModel call({
    Object? answer = const $CopyWithPlaceholder(),
    Object? key = const $CopyWithPlaceholder(),
    Object? question = const $CopyWithPlaceholder(),
  }) {
    return SecurityQuestionModel(
      answer: answer == const $CopyWithPlaceholder()
          ? _value.answer
          // ignore: cast_nullable_to_non_nullable
          : answer as String?,
      key: key == const $CopyWithPlaceholder() || key == null
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as String,
      question: question == const $CopyWithPlaceholder() || question == null
          ? _value.question
          // ignore: cast_nullable_to_non_nullable
          : question as String,
    );
  }
}

extension $SecurityQuestionModelCopyWith on SecurityQuestionModel {
  /// Returns a callable class that can be used as follows: `instanceOfSecurityQuestionModel.copyWith(...)` or like so:`instanceOfSecurityQuestionModel.copyWith.fieldName(...)`.
  _$SecurityQuestionModelCWProxy get copyWith =>
      _$SecurityQuestionModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecurityQuestionModel _$SecurityQuestionModelFromJson(
        Map<String, dynamic> json) =>
    SecurityQuestionModel(
      question: json['question'] as String,
      answer: json['answer'] as String?,
      key: json['key'] as String,
    );

Map<String, dynamic> _$SecurityQuestionModelToJson(
        SecurityQuestionModel instance) =>
    <String, dynamic>{
      'question': instance.question,
      'key': instance.key,
      'answer': instance.answer,
    };

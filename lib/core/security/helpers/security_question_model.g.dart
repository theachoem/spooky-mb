// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_question_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SecurityQuestionModelCWProxy {
  SecurityQuestionModel question(String question);

  SecurityQuestionModel answer(String? answer);

  SecurityQuestionModel key(String key);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SecurityQuestionModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SecurityQuestionModel(...).copyWith(id: 12, name: "My name")
  /// ````
  SecurityQuestionModel call({
    String? question,
    String? answer,
    String? key,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSecurityQuestionModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSecurityQuestionModel.copyWith.fieldName(...)`
class _$SecurityQuestionModelCWProxyImpl
    implements _$SecurityQuestionModelCWProxy {
  const _$SecurityQuestionModelCWProxyImpl(this._value);

  final SecurityQuestionModel _value;

  @override
  SecurityQuestionModel question(String question) => this(question: question);

  @override
  SecurityQuestionModel answer(String? answer) => this(answer: answer);

  @override
  SecurityQuestionModel key(String key) => this(key: key);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SecurityQuestionModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SecurityQuestionModel(...).copyWith(id: 12, name: "My name")
  /// ````
  SecurityQuestionModel call({
    Object? question = const $CopyWithPlaceholder(),
    Object? answer = const $CopyWithPlaceholder(),
    Object? key = const $CopyWithPlaceholder(),
  }) {
    return SecurityQuestionModel(
      question: question == const $CopyWithPlaceholder() || question == null
          // ignore: unnecessary_non_null_assertion
          ? _value.question!
          // ignore: cast_nullable_to_non_nullable
          : question as String,
      answer: answer == const $CopyWithPlaceholder()
          ? _value.answer
          // ignore: cast_nullable_to_non_nullable
          : answer as String?,
      key: key == const $CopyWithPlaceholder() || key == null
          // ignore: unnecessary_non_null_assertion
          ? _value.key!
          // ignore: cast_nullable_to_non_nullable
          : key as String,
    );
  }
}

extension $SecurityQuestionModelCopyWith on SecurityQuestionModel {
  /// Returns a callable class that can be used as follows: `instanceOfSecurityQuestionModel.copyWith(...)` or like so:`instanceOfSecurityQuestionModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
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

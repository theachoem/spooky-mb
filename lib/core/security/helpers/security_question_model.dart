import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'security_question_model.g.dart';

@CopyWith()
@JsonSerializable()
class SecurityQuestionModel {
  final String question;
  final String key;
  final String? answer;

  SecurityQuestionModel({
    required this.question,
    required this.answer,
    required this.key,
  });

  Map<String, dynamic> toJson() => _$SecurityQuestionModelToJson(this);
  factory SecurityQuestionModel.fromJson(Map<String, dynamic> json) => _$SecurityQuestionModelFromJson(json);
}

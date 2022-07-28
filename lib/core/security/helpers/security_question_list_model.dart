import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/security/helpers/security_question_model.dart';

part 'security_question_list_model.g.dart';

@JsonSerializable()
class SecurityQuestionListModel {
  final List<SecurityQuestionModel>? items;
  SecurityQuestionListModel(this.items);

  Map<String, dynamic> toJson() => _$SecurityQuestionListModelToJson(this);
  factory SecurityQuestionListModel.fromJson(Map<String, dynamic> json) => _$SecurityQuestionListModelFromJson(json);
}

import 'package:spooky/core/security/helpers/security_question_list_model.dart';
import 'package:spooky/core/storages/base_object_storages/object_storage.dart';

class SecurityQuestionsStorage extends ObjectStorage<SecurityQuestionListModel> {
  @override
  SecurityQuestionListModel decode(Map<String, dynamic> json) {
    return SecurityQuestionListModel.fromJson(json);
  }

  @override
  Map<String, dynamic> encode(SecurityQuestionListModel object) {
    return object.toJson();
  }
}

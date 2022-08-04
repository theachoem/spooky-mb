import 'package:spooky/core/security/helpers/security_question_list_model.dart';
import 'package:spooky/core/storages/base_object_storages/object_storage.dart';
import 'package:spooky/core/storages/storage_adapters/base_storage_adapter.dart';
import 'package:spooky/core/storages/storage_adapters/default_storage_adapter.dart';
import 'package:spooky/core/storages/storage_adapters/secure_storage_adapter.dart';

class SecurityQuestionsStorage extends ObjectStorage<SecurityQuestionListModel> {
  @override
  Future<BaseStorageAdapter<String>> get adapter async => SecureStorageAdapter();

  @override
  SecurityQuestionListModel decode(Map<String, dynamic> json) {
    return SecurityQuestionListModel.fromJson(json);
  }

  @override
  Map<String, dynamic> encode(SecurityQuestionListModel object) {
    return object.toJson();
  }

  @override
  Future<String?> read() async {
    final value = await (await adapter).read(key: key);

    if (value == null) {
      final oldAdapter = DefaultStorageAdapter<String>();
      final oldValue = await oldAdapter.read(key: key);
      return oldValue;
    }

    return value;
  }
}

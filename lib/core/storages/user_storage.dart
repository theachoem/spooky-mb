import 'package:spooky/core/objects/user_object.dart';
import 'package:spooky/core/storages/base_object_storages/object_storage.dart';

class UserStorage extends ObjectStorage<UserObject> {
  static final UserStorage instance = UserStorage._();

  UserStorage._();

  UserObject get initialData => _initialData ?? UserObject(nickname: null);
  UserObject? _initialData;

  Future<void> load() async {
    _initialData = await readObject();
  }

  @override
  UserObject decode(Map<String, dynamic> json) => UserObject.fromJson(json);

  @override
  Map<String, dynamic> encode(UserObject object) => object.toJson();
}

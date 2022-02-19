import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spooky/core/storages/base_storages/enum_storage.dart';

class FakeEnumStorage extends EnumStorage<FakeType> {
  @override
  List<FakeType> get values => FakeType.values;
}

enum FakeType {
  ac,
  bc,
}

void main() {
  SharedPreferences.setMockInitialValues({});
  FakeEnumStorage storage = FakeEnumStorage();
  group('FakeEnumStorage', () {
    test('return FakeType.bc if enum value is set', () async {
      await storage.writeEnum(FakeType.bc);
      FakeType? result = await storage.readEnum();
      expect(result, FakeType.bc);
    });

    test('return null if storage was cleared', () async {
      await storage.remove();
      FakeType? result = await storage.readEnum();
      expect(result, null);
    });
  });
}

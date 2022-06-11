import 'package:spooky/core/models/theme_model.dart';
import 'package:spooky/core/storages/base_object_storages/object_storage.dart';
import 'package:spooky/theme/m3/m3_color.dart';

class ThemeStorage extends ObjectStorage<ThemeModel> {
  /// access theme without context. [not recommended]
  /// prefer context.read<ThemeProvider>.theme instead.
  static ThemeModel get theme => _theme!;
  static ThemeModel? _theme;

  @override
  ThemeModel decode(Map<String, dynamic> json) {
    ThemeModel object = ThemeModel.fromJson(json);
    return object;
  }

  @override
  Map<String, dynamic> encode(ThemeModel object) {
    M3Color.setSchemes(object.colorSeed);
    _theme = object;
    return object.toJson();
  }

  @override
  Future<ThemeModel?> readObject() async {
    ThemeModel? theme = await super.readObject();
    return setup(theme);
  }

  @override
  Future<void> writeObject(ThemeModel object) async {
    await super.writeObject(object);
    setup(object);
  }

  Future<ThemeModel> setup(ThemeModel? theme) async {
    _theme = theme ?? ThemeModel.start();
    await M3Color.setSchemes(_theme!.colorSeed);
    return _theme!;
  }
}

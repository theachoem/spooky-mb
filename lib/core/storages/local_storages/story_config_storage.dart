import 'package:spooky/core/models/story_config_model.dart';
import 'package:spooky/core/storages/base_object_storages/bool_storage.dart';
import 'package:spooky/core/storages/base_object_storages/enum_storage.dart';
import 'package:spooky/core/storages/base_object_storages/object_storage.dart';
import 'package:spooky/core/types/sort_type.dart';
import 'package:spooky/widgets/sp_story_list/sp_story_list.dart';

class StoryConfigStorage extends ObjectStorage<StoryConfigModel> {
  static final StoryConfigStorage instance = StoryConfigStorage._();
  StoryConfigStorage._();

  // DEFAULT VALUE
  bool get prioritied => currentObject.prioritied ?? true;
  bool get disableDatePicker => currentObject.disableDatePicker ?? false;
  SortType get sortType => currentObject.sortType ?? SortType.newToOld;
  SpListLayoutType get layoutType => currentObject.layoutType ?? SpListLayoutType.diary;

  StoryConfigModel? _currentObject;
  StoryConfigModel get currentObject => _currentObject ?? StoryConfigModel();

  @override
  Future<void> writeObject(StoryConfigModel object) {
    return super.writeObject(object).then((value) => _currentObject = object);
  }

  @override
  StoryConfigModel decode(Map<String, dynamic> json) => StoryConfigModel.fromJson(json);

  @override
  Map<String, dynamic> encode(StoryConfigModel object) => object.toJson();

  @override
  Future<StoryConfigModel?> readObject() async {
    _currentObject = await super.readObject();

    if (_currentObject?.layoutType != null) SpListLayoutTypeStorage().remove();
    if (_currentObject?.sortType != null) SortTypeStorage().remove();
    if (_currentObject?.prioritied != null) PriorityStarredStorage().remove();

    SpListLayoutType? layoutType = _currentObject?.layoutType ?? await SpListLayoutTypeStorage().readEnum();
    SortType? sortType = _currentObject?.sortType ?? await SortTypeStorage().readEnum();
    bool? prioritied = _currentObject?.prioritied ?? await PriorityStarredStorage().read();

    return StoryConfigModel(
      layoutType: layoutType,
      sortType: sortType,
      prioritied: prioritied,
      disableDatePicker: _currentObject?.disableDatePicker,
    );
  }

  SortType? sortTypeFromString(String? element) {
    return SortTypeStorage().fromString(element);
  }
}

////////////////////////
/// RELATED STORAGES ///
////////////////////////

class PriorityStarredStorage extends BoolStorage {}

class SortTypeStorage extends EnumStorage<SortType> {
  @override
  List<SortType> get values => SortType.values;
}

class SpListLayoutTypeStorage extends EnumStorage<SpListLayoutType> {
  @override
  List<SpListLayoutType> get values => SpListLayoutType.values;

  @override
  Future<void> writeEnum(SpListLayoutType value) {
    return super.writeEnum(value);
  }
}

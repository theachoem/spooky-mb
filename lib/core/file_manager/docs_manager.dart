import 'package:spooky/core/file_manager/base_file_manager.dart';
import 'package:spooky/core/file_manager/base_fm_constructor_mixin.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';

class DocsManager extends BaseFileManager {
  @override
  FilePath get parentPathEnum => FilePath.docs;

  /// eg. $appPath/$parentPathStr/2022/Jan/7/
  @override
  String constructParentPath(BaseModel model) {
    model as StoryModel;
    String? year = model.createdAt?.year.toString();
    String? month = DateFormatHelper.toNameOfMonth().format(model.createdAt!);
    String? day = model.createdAt!.day.toString();
    return [appPath, parentPath, year, month, day, model.documentId].join("/");
  }

  Future<List<StoryModel>?> fetchAll({
    required int year,
    required int month,
  }) async {
    return beforeExec<List<StoryModel>>(() async {
      return [];
    });
  }

  Future<List<StoryModel>?> fetchChangesHistory({
    required DateTime date,
    required String id,
  }) async {
    return beforeExec<List<StoryModel>>(() async {
      return [];
    });
  }
}

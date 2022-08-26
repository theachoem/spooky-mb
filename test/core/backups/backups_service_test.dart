// ignore_for_file: avoid_print, unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:spooky/core/backups/backups_service.dart';
import 'package:spooky/core/backups/models/backups_model.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

void main() async {
  await FileHelper.initialFile();

  group("BackupsService", () {
    test("constructTables", () async {
      BackupsService service = BackupsService.instance;
      Map<String, dynamic> tables = await service.constructTables(service.databases);
      print(tables);
    });

    test("constructBackupsModel", () async {
      DateTime currentDate = DateTime(2022, 12, 24, 10, 10);
      BackupsService service = BackupsService.instance;
      BackupsModel model = await service.constructBackupsModel(service.databases, currentDate);
      expect(model.metaData.fileName, "Backup::1::1671851400000::Device Model::device_id");
      expect(model.metaData.fileNameWithExt, "Backup::1::1671851400000::Device Model::device_id.json");
    });
  });
}

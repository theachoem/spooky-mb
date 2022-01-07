import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:spooky/core/file_manager/docs_manager.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

void main() async {
  DocsManager manager = DocsManager();
  await FileHelper.initialFile();
  group('DocsManager', () {
    test('constructParentPath', () async {
      String path = manager.constructParentPath(StoryModel(
        documentId: '1641474725533',
        fileId: '2641474725533',
        starred: false,
        feeling: null,
        title: 'title',
        createdAt: null,
        pathDate: DateTime(2022, 1, 7),
        plainText: '',
        document: [],
      ));
      expect(path, Directory.current.path + '/docs/2022/Jan/7/1641474725533');
    });
  });
}

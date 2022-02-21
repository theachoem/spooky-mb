// https://stackoverflow.com/questions/67064178/how-to-open-a-file-with-a-custom-file-extension-from-another-app-with-my-flutter
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spooky/core/file_managers/story_file_manager.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/utils/helpers/file_helper.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class OpenFileUrlService {
  static const platform = MethodChannel("spooky@juniorise");
  static void getOpenFileUrl(BuildContext context) async {
    dynamic url = await platform.invokeMethod("getOpenFileUrl");
    if (url != null) {
      String _url = url.toString();
      String packageName = await PackageInfo.fromPlatform().then((value) => value.packageName);

      List<String> splitted = _url.split("/");
      int range = splitted.lastIndexWhere((e) => e == packageName);

      // com.juniorise.spooky/files
      String path = FileHelper.exposedDirectory.path + "/" + splitted.getRange(range + 2, splitted.length).join("/");

      File file = File(path);
      if (file.existsSync()) {
        StoryModel? story = await StoryFileManager().fetchOne(file);
        if (story != null) {
          Navigator.of(context).pushNamed(
            SpRouteConfig.detail,
            arguments: DetailArgs(
              initialStory: story,
              intialFlow: DetailViewFlowType.update,
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => _JsonViewer(json: file.readAsStringSync()),
            ),
          );
        }
      }
    }
  }
}

class _JsonViewer extends StatelessWidget {
  const _JsonViewer({
    Key? key,
    required this.json,
  }) : super(key: key);

  final String? json;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: Text("Json"),
      ),
    );
  }
}

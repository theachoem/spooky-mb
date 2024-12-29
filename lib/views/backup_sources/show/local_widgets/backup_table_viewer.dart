import 'package:flutter/material.dart';
import 'package:spooky/core/databases/adapters/base_db_adapter.dart';
import 'package:spooky/core/databases/adapters/objectbox/story_box.dart';
import 'package:spooky/core/databases/adapters/objectbox/tag_box.dart';
import 'package:spooky/core/databases/models/base_db_model.dart';
import 'package:spooky/core/databases/models/collection_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/databases/models/tag_db_model.dart';
import 'package:spooky/core/extensions/string_extension.dart';
import 'package:spooky/core/services/backup_sources/base_backup_source.dart';
import 'package:spooky/core/services/date_format_service.dart';
import 'package:spooky/widgets/story_list/story_list.dart';

class BackupTableViewer extends StatefulWidget {
  const BackupTableViewer({
    super.key,
    required this.tableContents,
    required this.tableName,
  });

  final String tableName;
  final List<Map<String, dynamic>> tableContents;

  @override
  State<BackupTableViewer> createState() => _BackupTableViewerState();
}

class _BackupTableViewerState extends State<BackupTableViewer> {
  late final BaseDbAdapter<BaseDbModel> database;
  List<BaseDbModel>? loadedModels;

  bool loaded = false;
  String? error;

  @override
  void initState() {
    database = BaseBackupSource.databases.firstWhere((e) => e.tableName == widget.tableName);
    super.initState();

    load();
  }

  Future<void> load() async {
    try {
      if (database is StoryBox) {
        loadedModels = widget.tableContents.map(database.modelFromJson).toList();
        loaded = true;
        setState(() {});
      } else if (database is TagBox) {
        loadedModels = widget.tableContents.map(database.modelFromJson).toList();
        loaded = true;
        setState(() {});
      } else {
        loaded = true;
      }
    } catch (e) {
      error = e.toString();
      loaded = true;
      Future.microtask(() => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tableName.capitalize),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (!loaded) return const Center(child: CircularProgressIndicator.adaptive());
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(error!),
        ),
      );
    }

    if (loadedModels?.firstOrNull is StoryDbModel) {
      return StoryList(
        viewOnly: true,
        stories: CollectionDbModel(items: loadedModels?.whereType<StoryDbModel>().toList() ?? []),
        onChanged: (_) {},
        onDeleted: () {},
      );
    } else if (loadedModels?.firstOrNull is TagDbModel) {
      final tags = loadedModels?.whereType<TagDbModel>().toList() ?? [];
      return ListView.builder(
        itemCount: tags.length,
        itemBuilder: (context, index) {
          final tag = tags[index];
          return ListTile(
            leading: const Icon(Icons.sell),
            title: Text(tag.title),
            subtitle: Text(DateFormatService.yMEd_jmsNullable(tag.updatedAt) ?? 'N/A'),
          );
        },
      );
    }

    return ListView.builder(
      itemCount: widget.tableContents.length,
      itemBuilder: (context, index) {
        Map<dynamic, dynamic> content = widget.tableContents[index];
        return ListTile(
          title: Text(
            content['title'].toString(),
          ),
        );
      },
    );
  }
}

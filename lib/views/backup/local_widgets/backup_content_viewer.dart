import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/extensions/string_extension.dart';
import 'package:spooky/core/objects/backup_object.dart';
import 'package:spooky/core/services/date_format_service.dart';
import 'package:spooky/providers/backup_provider.dart';
import 'package:spooky/views/backup/local_widgets/backup_table_viewer.dart';
import 'package:spooky/widgets/sp_nested_navigation.dart';

class BackupContentViewer extends StatelessWidget {
  const BackupContentViewer({
    super.key,
    required this.backup,
  });

  final BackupObject backup;

  void restore(BuildContext context) {
    context.read<BackupProvider>().forceRestore(backup, context);
  }

  @override
  Widget build(BuildContext context) {
    String? backupAt = DateFormatService.yMEd_jmsNullable(backup.fileInfo.createdAt);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: backupAt != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    backup.fileInfo.device.model,
                    style: TextTheme.of(context).titleSmall,
                  ),
                  Text(
                    backupAt,
                    style: TextTheme.of(context).bodyMedium,
                  ),
                ],
              )
            : Text(backup.fileInfo.device.model),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FilledButton.icon(
        icon: const Icon(Icons.restore),
        label: const Text("Restore"),
        onPressed: () => restore(context),
      ),
      body: ListView.builder(
        itemCount: backup.tables.length,
        itemBuilder: (context, index) {
          final table = backup.tables.entries.elementAt(index);
          final value = table.value;
          final documentCount = value is List ? value.length : 0;

          return ListTile(
            leading: const Icon(Icons.library_books),
            title: Text(table.key.capitalize),
            subtitle: Text(documentCount > 1 ? '$documentCount documents' : '$documentCount document'),
            onTap: () {
              if (value is List) {
                List<Map<String, dynamic>> tableContents = value.whereType<Map<String, dynamic>>().toList();
                SpNestedNavigation.maybeOf(context)?.push(
                  BackupTableViewer(
                    tableName: table.key,
                    tableContents: tableContents,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

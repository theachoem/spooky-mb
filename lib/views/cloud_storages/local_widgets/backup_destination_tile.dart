import 'package:community_material_icon/community_material_icon.dart';

import 'package:flutter/material.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/cloud_storages/cloud_storages_view_model.dart';
import 'package:spooky/widgets/sp_button.dart';

class BackupDestinationTile extends StatelessWidget {
  const BackupDestinationTile({
    Key? key,
    required this.viewModel,
    required this.destination,
  }) : super(key: key);

  final CloudStoragesViewModel viewModel;
  final BaseBackupDestination destination;

  Widget buildBackupButton(BaseBackupDestination destination) {
    String cloudId = destination.cloudId;
    return ValueListenableBuilder<Set<String>>(
      valueListenable: viewModel.doingBackupIdsNotifier,
      builder: (context, ids, child) {
        bool doingBackup = ids.contains(cloudId);
        bool backupable = !viewModel.synced(cloudId) && viewModel.hasStory && !doingBackup;
        return AnimatedContainer(
          duration: ConfigConstant.duration,
          transform: Matrix4.identity()..translate(0.0, doingBackup ? -8.0 : 0.0),
          child: AnimatedOpacity(
            opacity: doingBackup ? 0 : 1,
            duration: ConfigConstant.duration,
            child: SpButton(
              iconData: viewModel.synced(cloudId) ? Icons.check : null,
              label: viewModel.synced(cloudId) ? "Synced" : "Backup now",
              onTap: backupable ? () => viewModel.backup(destination) : null,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: ConfigConstant.margin2,
        vertical: ConfigConstant.margin0,
      ),
      child: Material(
        borderOnForeground: false,
        type: MaterialType.button,
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: ConfigConstant.circlarRadius2,
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const ListTile(
                leading: CircleAvatar(child: Icon(CommunityMaterialIcons.google_drive)),
                contentPadding: EdgeInsets.zero,
                title: Text("Google Drive"),
                subtitle: Text("theacheng.g6@gmail.com"),
              ),
              Wrap(
                children: [
                  SpButton(
                    label: "Login",
                    onTap: () {},
                  ),
                  const SizedBox(width: ConfigConstant.margin1),
                  buildBackupButton(destination),
                  const SizedBox(width: ConfigConstant.margin1),
                  SpButton(
                    label: "View",
                    onTap: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

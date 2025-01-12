import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/extensions/color_scheme_extensions.dart';
import 'package:spooky/core/services/date_format_service.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/providers/backup_provider.dart';
import 'package:spooky/views/backup/backup_view.dart';

class BackupTile extends StatelessWidget {
  const BackupTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackupProvider>(context);

    if (provider.source.isSignedIn == true) {
      return buildSignedInTile(context, provider);
    } else {
      return buildUnsignInTile(context, provider);
    }
  }

  Widget buildSignedInTile(BuildContext context, BackupProvider provider) {
    Widget leading;
    Widget? subtitle;

    if (provider.syncing) {
      leading = const SizedBox.square(
        dimension: 24.0,
        child: CircularProgressIndicator.adaptive(),
      );
      subtitle = const Text("Syncing...");
    } else if (provider.synced) {
      leading = Icon(
        Icons.cloud_done,
        color: ColorScheme.of(context).bootstrap.success.color,
      );
      subtitle = Text(DateFormatService.yMEd_jmsNullable(provider.lastSyncedAt) ?? '...');
    } else {
      leading = const Icon(Icons.cloud_upload_outlined);
      subtitle = provider.canBackup() ? const Text('Some data hasn\'t synced yet') : null;
    }

    if (provider.source.smallImageUrl != null) {
      leading = Transform.scale(
        scale: 1.5,
        child: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(provider.source.smallImageUrl!),
          radius: 12.0,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: leading,
          title: RichText(
            text: TextSpan(
              text: 'Backups ',
              style: TextTheme.of(context).bodyLarge,
              children: [
                if (provider.synced)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.cloud_done,
                      color: ColorScheme.of(context).bootstrap.success.color,
                      size: 16.0,
                    ),
                  ),
              ],
            ),
          ),
          subtitle: subtitle,
          onTap: () => BackupRoute().push(context),
        ),
        if (!provider.syncing && !provider.synced)
          Container(
            margin: const EdgeInsets.only(left: 52.0),
            transform: Matrix4.identity()..translate(0.0, -4.0),
            child: OutlinedButton.icon(
              label: const Text("Sync"),
              onPressed: provider.syncing
                  ? null
                  : () {
                      provider.setSyncing(true);
                      provider.syncBackupAcrossDevices();
                    },
            ),
          )
      ],
    );
  }

  Widget buildUnsignInTile(BuildContext context, BackupProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 0.0,
      children: [
        const ListTile(
          leading: Icon(Icons.backup_outlined),
          title: Text('Backup'),
          subtitle: Text("Sign in to Google Drive"),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        Container(
          margin: const EdgeInsets.only(left: 52.0),
          transform: Matrix4.identity()..translate(0.0, -8.0),
          child: FilledButton.icon(
            icon: Icon(MdiIcons.googleDrive),
            label: const Text("Sign In"),
            onPressed: () => signIn(context, provider),
          ),
        )
      ],
    );
  }

  Future<void> signIn(BuildContext context, BackupProvider provider) {
    return MessengerService.of(context).showLoading(
      debugSource: '$runtimeType#signIn',
      future: () => provider.signIn(),
    );
  }
}

import 'dart:math';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:spooky/core/backups/backups_service.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/backups/providers/base_cloud_provider.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_button.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';

class CloudDestinationTile extends StatefulWidget {
  const CloudDestinationTile({
    Key? key,
    required this.destination,
    required this.hasStory,
  }) : super(key: key);

  final BaseBackupDestination destination;
  final bool hasStory;

  @override
  State<CloudDestinationTile> createState() => _CloudDestinationTileState();
}

class _CloudDestinationTileState extends State<CloudDestinationTile> {
  Future<void> backup(
    BaseBackupDestination destination,
    BaseCloudProvider provider,
  ) async {
    provider.setLoading(1, true);
    await BackupsService.instance.backup(destination: destination);
    await provider.load(true);
    provider.setLoading(1, false);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.destination.buildWithConsumer(
      builder: (context, provider, child) {
        String? name = provider.name;
        String? username = provider.username;
        String cloudName = provider.cloudName;
        bool isSignedIn = provider.isSignedIn;
        DateTime? lastBackup = provider.lastBackup;
        bool released = provider.released;
        // ValueNotifier<bool>? loadingBackupNotifier = provider.loadingBackupNotifier;
        ValueNotifier<bool>? doingBackupNotifier = provider.doingBackupNotifier;

        String title;
        String subtitle;

        if (isSignedIn) {
          if (lastBackup != null) {
            title = username ?? name ?? tr("msg.unknown");
            subtitle = tr(
              "msg.last_synced",
              namedArgs: {
                'DATE': DateFormatHelper.dateTimeFormat().format(lastBackup),
              },
            );
          } else {
            title = name ?? tr("msg.unknown");
            subtitle = username ?? tr("msg.logged_in");
          }
        } else {
          title = cloudName;
          subtitle = tr("msg.login_to_sync_data");
        }

        if (!released) {
          subtitle = tr("msg.coming_soon");
        }

        return Container(
          margin: const EdgeInsets.only(bottom: ConfigConstant.margin2),
          child: SpPopupMenuButton(
            dyGetter: (dy) => dy + 24,
            dxGetter: (dx) => MediaQuery.of(context).size.width / 2,
            items: (context) {
              return buildTilePopUpItems(
                context,
                provider,
              );
            },
            builder: (callback) {
              return Stack(
                children: [
                  Material(
                    borderOnForeground: false,
                    type: MaterialType.button,
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: ConfigConstant.circlarRadius2,
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: provider.isSignedIn ? callback : null,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ListTile(
                              leading: buildAvatar(),
                              contentPadding: EdgeInsets.zero,
                              title: Text(title),
                              subtitle: Text(subtitle),
                            ),
                            if (released) buildTileActions(isSignedIn, provider, doingBackupNotifier, lastBackup)
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   top: ConfigConstant.margin0,
                  //   right: ConfigConstant.margin0,
                  //   child: SpIconButton(
                  //     onPressed: () => provider.load(),
                  //     icon: const Icon(
                  //       Icons.refresh,
                  //       size: ConfigConstant.iconSize1,
                  //     ),
                  //   ),
                  // ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget buildTileActions(
    bool isSignedIn,
    BaseCloudProvider provider,
    ValueNotifier<bool> doingBackupNotifier,
    DateTime? lastBackup,
  ) {
    String? cloudFileId = provider.lastMetaData?.cloudFile.id;
    return Wrap(
      children: [
        if (!isSignedIn)
          SpButton(
            label: tr("button.login"),
            onTap: () {
              provider.signIn();
            },
          )
        else ...[
          buildBackupButton(doingBackupNotifier, provider),
          if (lastBackup != null && cloudFileId != null) ConfigConstant.sizedBoxW1,
          if (lastBackup != null && cloudFileId != null)
            SpButton(
              label: tr("button.view"),
              backgroundColor: M3Color.of(context).secondary,
              foregroundColor: M3Color.of(context).onSecondary,
              onTap: () async {
                await Navigator.of(context)
                    .pushNamed(
                  SpRouter.backupsDetails.path,
                  arguments: BackupsDetailArgs(
                    destination: provider.destination,
                    cloudFiles: provider.destination.metaDatasFromCloudFiles(provider.fileList),
                    initialCloudFile: provider.lastMetaData!.cloudFile,
                  ),
                )
                    .then((result) {
                  if (result is bool && result) {
                    provider.load(true);
                  }
                });
              },
            ),
        ],
        const SizedBox(width: 2.0),
        buildRefreshButton(
          provider.loadingBackupNotifier,
          provider,
        ),
      ],
    );
  }

  Widget buildRefreshButton(
    ValueNotifier<bool> loadingBackupNotifier,
    BaseCloudProvider provider,
  ) {
    return ValueListenableBuilder<bool>(
      valueListenable: loadingBackupNotifier,
      child: LoopAnimationBuilder<int>(
        tween: IntTween(begin: 0, end: 180),
        duration: const Duration(seconds: 1),
        builder: (context, value, child) {
          return Transform.rotate(
            angle: value * pi / 180,
            child: Icon(
              Icons.sync,
              color: M3Color.of(context).onTertiary,
            ),
          );
        },
      ),
      builder: (context, loading, child) {
        return SpIconButton(
          backgroundColor: M3Color.of(context).tertiary,
          onPressed: () => provider.load(false),
          icon: SpAnimatedIcons(
            showFirst: !loading,
            duration: ConfigConstant.duration * 2,
            firstChild: Icon(
              Icons.refresh,
              color: M3Color.of(context).onTertiary,
            ),
            secondChild: child!,
          ),
        );
      },
    );
  }

  List<SpPopMenuItem> buildTilePopUpItems(BuildContext context, BaseCloudProvider provider) {
    return [
      if (widget.destination.canLaunchSource())
        SpPopMenuItem(
          title: tr("button.photo"),
          leadingIconData: CommunityMaterialIcons.folder_google_drive,
          onPressed: () async {
            widget.destination.viewSource(context);
          },
        ),
      SpPopMenuItem(
        title: tr("button.logout"),
        leadingIconData: Icons.logout,
        titleStyle: TextStyle(color: M3Color.of(context).error),
        onPressed: () async {
          OkCancelResult result = await showOkCancelAlertDialog(
            context: context,
            title: tr("alert.logout.title"),
            message: tr("alert.logout.message"),
            isDestructiveAction: true,
            cancelLabel: tr("button.cancel"),
          );
          switch (result) {
            case OkCancelResult.ok:
              await provider.signOut();
              break;
            case OkCancelResult.cancel:
              break;
          }
        },
      ),
    ];
  }

  Widget buildBackupButton(
    ValueNotifier<bool> doingBackupNotifier,
    BaseCloudProvider provider,
  ) {
    return ValueListenableBuilder<bool>(
      valueListenable: doingBackupNotifier,
      builder: (context, loading, child) {
        bool synced = provider.synced;
        bool backupable = !synced && !loading;

        String? label;
        Color? backgroundColor;
        Color? foregroundColor;

        if (synced) {
          label = tr("msg.synced");
          backgroundColor = M3Color.of(context).readOnly.surface5;
          foregroundColor = M3Color.of(context).onSurface;
        } else {
          label = tr("button.backup_now");
          backgroundColor = null;
          foregroundColor = null;
        }

        return AnimatedContainer(
          duration: ConfigConstant.duration,
          transform: Matrix4.identity()..translate(0.0, loading ? -8.0 : 0.0),
          child: AnimatedOpacity(
            opacity: loading ? 0 : 1,
            duration: ConfigConstant.duration,
            child: SpButton(
              iconData: synced ? Icons.check : null,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              label: label,
              onTap: backupable ? () => onBackup(context, provider) : null,
            ),
          ),
        );
      },
    );
  }

  void onBackup(BuildContext context, BaseCloudProvider provider) {
    if (!widget.hasStory) {
      showOkAlertDialog(
        context: context,
        title: tr("alert.no_story_found.title"),
        message: tr("alert.no_story_found.message"),
        okLabel: tr("button.ok"),
      );
    } else {
      backup(widget.destination, provider);
    }
  }

  Widget buildAvatar() {
    return CircleAvatar(
      backgroundColor: M3Color.dayColorsOf(context)[5],
      child: Icon(
        widget.destination.iconData,
        color: M3Color.of(context).onTertiary,
      ),
    );
  }
}

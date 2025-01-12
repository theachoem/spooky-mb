part of 'backup_view.dart';

class _BackupAdaptive extends StatelessWidget {
  const _BackupAdaptive(this.viewModel);

  final BackupViewModel viewModel;

  final double avatarSize = 56;

  @override
  Widget build(BuildContext context) {
    final BackupProvider provider = Provider.of<BackupProvider>(context);

    return SpDefaultScrollController(builder: (context, controller) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Backup Histories"),
        ),
        body: Stack(children: [
          if (viewModel.hasData) buildTimelineDivider(),
          RefreshIndicator.adaptive(
            onRefresh: () => viewModel.load(context),
            child: CustomScrollView(
              controller: controller,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                buildSliverProfileTile(provider),
                if (viewModel.loading) ...[
                  buildSliverLoading()
                ] else if (viewModel.hasData) ...[
                  buildSliverBackupList(context)
                ] else ...[
                  buildSliverEmpty()
                ]
              ],
            ),
          ),
        ]),
      );
    });
  }

  SliverToBoxAdapter buildSliverProfileTile(BackupProvider provider) {
    return SliverToBoxAdapter(
      child: UserProfileCollapsibleTile(
        viewModel: viewModel,
        source: provider.source,
        avatarSize: avatarSize,
      ),
    );
  }

  SliverPadding buildSliverEmpty() {
    return const SliverPadding(
      padding: EdgeInsets.all(16.0),
      sliver: SliverToBoxAdapter(
        child: Text("No backups found."),
      ),
    );
  }

  SliverPadding buildSliverLoading() {
    return const SliverPadding(
      padding: EdgeInsets.all(16.0),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  SliverPadding buildSliverBackupList(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16.0, top: 8.0),
      sliver: SliverList.builder(
        itemCount: viewModel.files?.length ?? 0,
        itemBuilder: (context, index) {
          return buildBackupGroup(context, viewModel.files![index]);
        },
      ),
    );
  }

  Widget buildBackupGroup(BuildContext context, CloudFileObject file) {
    final fileInfo = file.getFileInfo();

    return SpPopupMenuButton(
      smartDx: true,
      dyGetter: (dy) => dy + 36,
      items: (BuildContext context) {
        return [
          SpPopMenuItem(
            title: 'View',
            onPressed: () => viewModel.openCloudFile(context, file),
          ),
          SpPopMenuItem(
            title: 'Delete',
            titleStyle: TextStyle(color: ColorScheme.of(context).error),
            onPressed: () async {
              OkCancelResult userResponse = await showOkCancelAlertDialog(
                context: context,
                title: "Are you sure to delete this backup?",
                message: "You can't undo this action.",
                isDestructiveAction: true,
                okLabel: "Delete",
              );

              if (userResponse == OkCancelResult.ok && context.mounted) {
                await viewModel.deleteCloudFile(context, file);
              }
            },
          ),
        ];
      },
      builder: (callback) {
        return InkWell(
          onTap: callback,
          child: Container(
            padding: EdgeInsets.only(left: (avatarSize + 12) / 2 - 32 / 2),
            child: Row(
              spacing: 16.0,
              children: [
                if (fileInfo != null) buildMonogram(context, fileInfo.createdAt),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero.copyWith(right: 16.0),
                    title: Text(fileInfo?.device.model ?? 'Unknown'),
                    subtitle: Text(DateFormatService.yMEd_jmsNullable(fileInfo?.createdAt) ?? 'N/A'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTimelineDivider() {
    return Positioned(
      top: 0,
      bottom: 0,
      left: (avatarSize + 12) / 2,
      child: const VerticalDivider(
        width: 1,
        indent: 0.0,
      ),
    );
  }

  Widget buildMonogram(BuildContext context, DateTime date) {
    double monogramSize = 32;

    return Column(
      spacing: 4.0,
      children: [
        Container(
          width: monogramSize,
          color: ColorScheme.of(context).surface.withValues(),
          child: Text(
            DateFormatService.E(date),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextTheme.of(context).labelMedium,
          ),
        ),
        Container(
          width: monogramSize,
          height: monogramSize,
          decoration: BoxDecoration(
            color: ColorFromDayService(context: context).get(date.weekday),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            date.day.toString(),
            style: TextTheme.of(context).bodyMedium?.copyWith(color: ColorScheme.of(context).onPrimary),
          ),
        ),
      ],
    );
  }
}

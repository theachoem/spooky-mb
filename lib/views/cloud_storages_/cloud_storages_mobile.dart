part of clouds_storage_view;

class _CloudStoragesMobile extends StatelessWidget {
  final CloudStoragesViewModel viewModel;
  const _CloudStoragesMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
        title: const SpAppBarTitle(fallbackRouter: SpRouter.cloudStorage),
        actions: [
          SpThemeSwitcher(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2 - 4.0),
        children: [
          ...viewModel.destinations.map((des) {
            return buildDestinationTile(des);
          }).toList(),
        ],
      ),
    );
  }

  BackupsDestinationTile buildDestinationTile(BaseBackupDestination<BaseCloudProvider> destination) {
    return BackupsDestinationTile(
      destination: destination,
      avatarBuilder: (BuildContext context) {
        return buildTileIcon(
          context: context,
          destination: destination,
        );
      },
      actionsBuilder: (BuildContext context) {
        return [
          buildBackupButton(destination),
          ConfigConstant.sizedBoxW1,
          SpButton(
            label: "View detail",
            onTap: () {},
          )
        ];
      },
    );
  }

  Widget buildBackupButton(BaseBackupDestination destination) {
    String cloudId = destination.cloudId;
    return ValueListenableBuilder<Set<String>>(
      valueListenable: viewModel.doingBackupIdsNotifier,
      builder: (context, value, child) {
        bool loading = value.contains(destination.cloudId);
        bool backupable = !viewModel.synced(cloudId) && viewModel.hasStory && !loading;

        String? label;
        Color? backgroundColor;
        Color? foregroundColor;

        if (!viewModel.hasStory) {
          label = "No data to backup";
          backgroundColor = M3Color.of(context).secondary;
          foregroundColor = M3Color.of(context).onSecondary;
        } else if (viewModel.synced(cloudId)) {
          label = "Synced";
          backgroundColor = M3Color.of(context).primary.withOpacity(0.1);
          foregroundColor = M3Color.of(context).primary;
        } else {
          label = "Backup now";
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
              iconData: viewModel.synced(cloudId) ? Icons.check : null,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              label: label,
              onTap: backupable ? () => viewModel.backup(destination) : null,
            ),
          ),
        );
      },
    );
  }

  Widget buildTileIcon({
    required BuildContext context,
    required BaseBackupDestination destination,
  }) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: viewModel.doingBackupIdsNotifier,
      builder: (context, value, child) {
        bool loading = value.contains(destination.cloudId);
        return CircleAvatar(
          backgroundColor: M3Color.dayColorsOf(context)[5],
          child: SpAnimatedIcons(
            showFirst: !loading,
            firstChild: Icon(
              destination.iconData,
              color: M3Color.of(context).onTertiary,
            ),
            secondChild: LoopAnimation<int>(
              tween: IntTween(begin: 0, end: 180),
              builder: (context, child, value) {
                return Transform.rotate(
                  angle: value * pi / 180,
                  child: Icon(
                    Icons.sync,
                    color: M3Color.of(context).onTertiary,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

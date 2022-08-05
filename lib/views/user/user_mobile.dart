part of user_view;

class _UserMobile extends StatelessWidget {
  final UserViewModel viewModel;
  const _UserMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: MorphingAppBar(
        leading: const SpPopButton(),
        title: Text(
          currentUser?.displayName ?? "",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          if (viewModel.connectedProviders.isNotEmpty)
            SpIconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                OkCancelResult result = await showOkCancelAlertDialog(
                  context: context,
                  title: "Are you sure?",
                  message: "You can log in back anytime.",
                  isDestructiveAction: true,
                );
                switch (result) {
                  case OkCancelResult.ok:
                    viewModel.logout();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    break;
                  case OkCancelResult.cancel:
                    break;
                }
              },
            )
        ],
      ),
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          viewModel.scrollOffsetNotifier.value = notification.metrics.pixels;
          return false;
        },
        child: ListView(
          children: [
            if (currentUser != null)
              UserImageProfile(
                scrollOffsetNotifier: viewModel.scrollOffsetNotifier,
                currentUser: currentUser,
              ),
            ...SpSectionsTiles.divide(
              context: context,
              showTopDivider: true,
              sections: [
                buildProviders(context),
              ],
            ),
            const SizedBox(height: 400)
          ],
        ),
      ),
    );
  }

  SpSectionContents buildProviders(BuildContext context) {
    final connectedProviders = viewModel.availableProviders.values.toList();
    return SpSectionContents(
      headline: null,
      tiles: [
        ConfigConstant.sizedBoxH2,
        ...List.generate(
          connectedProviders.length,
          (index) {
            final providerInfo = connectedProviders[index];
            final connectedInfo = viewModel.getUserInfo(providerInfo.providerId);
            return buildProviderTile(
              context: context,
              title: "Connect with ${providerInfo.title}",
              iconData: providerInfo.iconData,
              connectedInfo: connectedInfo,
              onConnectPressed: () => viewModel.connect(providerInfo, context),
              onDisconnectPressed: () async => onDisconnect(providerInfo, context),
            );
          },
        ),
        ConfigConstant.sizedBoxH2,
        buildDeletionTile(context)
      ],
    );
  }

  Widget buildDeletionTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListTile(
        title: Text(SpRouter.accountDeletion.datas.title),
        iconColor: M3Color.of(context).error,
        trailing: const Icon(Icons.keyboard_arrow_right),
        leading: const Icon(Icons.delete),
        shape: RoundedRectangleBorder(
          borderRadius: ConfigConstant.circlarRadius2,
          side: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(SpRouter.accountDeletion.path);
        },
      ),
    );
  }

  Future<void> onDisconnect(AuthProviderDatas providerInfo, BuildContext context) async {
    if (viewModel.connectedProviders.length == 1) {
      MessengerService.instance.showSnackBar(
        "Keep at least one connected provider.",
        success: false,
      );
      return;
    }

    final providerId = providerInfo.providerId;
    final result = await showOkCancelAlertDialog(
      context: context,
      title: "Are you sure to disconnect?",
      okLabel: "Disconnect",
      isDestructiveAction: true,
    );

    switch (result) {
      case OkCancelResult.ok:
        final success = await MessengerService.instance.showLoading(
          future: () => viewModel.unlink(providerId, context),
          context: context,
          debugSource: "UserMobile#onDisconnect",
        );
        if (success == true) {
          MessengerService.instance.showSnackBar("Disconnect successfully", success: true);
        } else {
          MessengerService.instance.showSnackBar("Disconnect fail", success: false);
        }
        break;
      case OkCancelResult.cancel:
        break;
    }
  }

  ListTile buildProviderTile({
    required BuildContext context,
    required String title,
    required IconData iconData,
    required UserInfo? connectedInfo,
    required void Function() onConnectPressed,
    required void Function() onDisconnectPressed,
  }) {
    bool connected = connectedInfo?.uid != null;
    String label = connectedInfo?.displayName ?? title;
    String? subtitle = connectedInfo?.email;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: M3Color.of(context).secondary,
        child: Icon(iconData, color: M3Color.of(context).onSecondary),
      ),
      title: Text(label),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: SpAnimatedIcons(
        firstChild: Icon(Icons.check, color: M3Color.dayColorsOf(context)[4]),
        secondChild: const SizedBox.shrink(),
        showFirst: connected,
      ),
      onTap: () async {
        if (!connected) {
          onConnectPressed();
        } else {
          onDisconnectPressed();
        }
      },
    );
  }
}

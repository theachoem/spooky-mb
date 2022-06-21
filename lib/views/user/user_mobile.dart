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
        title: const SpAppBarTitle(fallbackRouter: router.SpRouter.user),
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
      headline: "Providers",
      tiles: [
        ...List.generate(
          connectedProviders.length,
          (index) {
            final providerInfo = connectedProviders[index];
            final connectedInfo = viewModel.getUserInfo(providerInfo.providerId);
            return buildProviderTile(
              context: context,
              title: providerInfo.title,
              iconData: providerInfo.iconData,
              connectedInfo: connectedInfo,
              onConnectPressed: () => viewModel.connect(providerInfo, context),
              onDisconnectPressed: () async => onDisconnect(providerInfo, context),
            );
          },
        ),
      ],
    );
  }

  Future<void> onDisconnect(AvailableAuthProvider providerInfo, BuildContext context) async {
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

class UserImageProfile extends StatelessWidget {
  late final String? profileUrl;
  final User currentUser;
  final ValueNotifier<double> scrollOffsetNotifier;

  UserImageProfile({
    Key? key,
    required this.scrollOffsetNotifier,
    required this.currentUser,
  }) : super(key: key) {
    profileUrl = maximizeImage(currentUser.photoURL);
  }

  String? maximizeImage(String? imageUrl) {
    if (imageUrl == null) return null;
    String lowQuality = "s96-c";
    String highQuality = "s0";
    return imageUrl.replaceAll(lowQuality, highQuality);
  }

  final double avatarSize = 72;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      final width = constraint.maxWidth;
      return ValueListenableBuilder(
        valueListenable: scrollOffsetNotifier,
        builder: (context, double offset, child) {
          final bool isCollapse = offset < 200;
          final avatarSize = isCollapse ? width : this.avatarSize;
          final padding = isCollapse ? EdgeInsets.zero : const EdgeInsets.all(16);
          return AnimatedContainer(
            duration: ConfigConstant.duration,
            curve: Curves.easeOutQuart,
            width: width,
            height: width,
            padding: padding,
            alignment: Alignment.bottomLeft,
            color: M3Color.of(context).background,
            child: AnimatedOpacity(
              duration: ConfigConstant.fadeDuration,
              curve: Curves.decelerate,
              opacity: offset < 350 ? 1 : 0,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  buildPhoto(avatarSize, isCollapse),
                  buildProfileInfoTile(isCollapse, context),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget buildProfileInfoTile(bool isCollapse, BuildContext context) {
    return AnimatedContainer(
      duration: ConfigConstant.duration,
      width: double.infinity,
      curve: Curves.easeOutQuart,
      height: 72,
      margin: EdgeInsets.only(left: isCollapse ? 0 : avatarSize + 16),
      decoration: BoxDecoration(
        borderRadius: isCollapse ? BorderRadius.zero : ConfigConstant.circlarRadius2,
        color: M3Color.of(context).primaryContainer.withOpacity(isCollapse ? 1 : 1),
      ),
      child: SpPopupMenuButton(
        dxGetter: (dx) => MediaQuery.of(context).size.width,
        dyGetter: (dy) => dy + kToolbarHeight + 24.0,
        items: (context) {
          return [
            SpPopMenuItem(
              title: "Identity",
              subtitle: currentUser.uid,
            ),
            if (currentUser.metadata.creationTime != null)
              SpPopMenuItem(
                title: "Created at",
                subtitle: DateFormatHelper.dateTimeFormat().format(currentUser.metadata.creationTime!),
              ),
            if (currentUser.metadata.lastSignInTime != null)
              SpPopMenuItem(
                title: "Last sign in",
                subtitle: DateFormatHelper.dateTimeFormat().format(currentUser.metadata.lastSignInTime!),
              ),
          ];
        },
        builder: (callback) {
          return ListTile(
            onTap: callback,
            title: Text(
              currentUser.displayName ?? "",
              style: TextStyle(color: M3Color.of(context).primary),
            ),
            subtitle: Text(
              currentUser.email ?? currentUser.uid,
              style: TextStyle(color: M3Color.of(context).primary),
            ),
            trailing: Icon(
              Icons.info,
              color: M3Color.of(context).primary,
            ),
          );
        },
      ),
    );
  }

  Widget buildPhoto(double avatarSize, bool isCollapse) {
    bool hasPhoto = profileUrl != null;
    return AnimatedContainer(
      duration: ConfigConstant.duration,
      curve: Curves.easeOutQuart,
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          isCollapse ? 0 : avatarSize,
        ),
        image: hasPhoto
            ? DecorationImage(
                image: CachedNetworkImageProvider(profileUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: !hasPhoto
          ? const Icon(
              Icons.person,
              size: ConfigConstant.iconSize5,
            )
          : null,
    );
  }
}

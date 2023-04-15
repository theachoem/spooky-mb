part of setting_view;

class _SettingMobile extends StatelessWidget {
  final SettingViewModel viewModel;
  const _SettingMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
        title: const SpAppBarTitle(fallbackRouter: SpRouter.setting),
        actions: const [
          InAppUpdateButton(),
          SecurityQuestionButton(),
          NotificationPermissionButton(),
          ConfigConstant.sizedBoxW0,
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: SpSectionsTiles.divide(
            context: context,
            sections: [
              SpSectionContents(
                headline: tr("section.user"),
                tiles: [
                  const CloudStorageTile(),
                  // ListTile(
                  //   leading: const Icon(Icons.person),
                  //   title: Text(SpRouter.user.title),
                  //   onTap: () {
                  //     Navigator.of(context).pushNamed(SpRouter.user.path);
                  //   },
                  // ),
                  ListTile(
                    leading: const Icon(Icons.color_lens),
                    title: Text(SpRouter.themeSetting.datas.title),
                    onTap: () {
                      Navigator.of(context).pushNamed(SpRouter.themeSetting.path);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.archive),
                    title: Text(SpRouter.archive.datas.title),
                    onTap: () {
                      Navigator.of(context).pushNamed(SpRouter.archive.path);
                    },
                  ),
                ],
              ),
              SpSectionContents(
                headline: tr("section.features"),
                tiles: [
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: Text(SpRouter.security.datas.title),
                    onTap: () async {
                      bool authenticated = await SecurityService().showLockIfHas(
                        context,
                        flowType: LockFlowType.middleware,
                      );
                      if (authenticated) {
                        Navigator.of(context).pushNamed(SpRouter.security.path);
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.music_note),
                    title: Text(SpRouter.soundList.datas.title),
                    onTap: () {
                      Navigator.of(context).pushNamed(SpRouter.soundList.path);
                    },
                  ),
                  ListTile(
                    leading: SizedBox(height: 40, child: Icon(Icons.extension, color: M3Color.of(context).primary)),
                    title: Text(SpRouter.addOn.datas.title),
                    subtitle: Text(SpRouter.addOn.datas.subtitle),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.of(context).pushNamed(SpRouter.addOn.path);
                    },
                  ),
                ],
              ),
              SpSectionContents(headline: tr("section.info"), tiles: [
                ListTile(
                  leading: const SizedBox(height: 40, child: Icon(Icons.privacy_tip_rounded)),
                  title: Text(tr("tile.privary_policy")),
                  onTap: () {
                    AppHelper.openLinkDialog(RemoteConfigStringKeys.linkToPrivacyPolicy.get());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.newspaper),
                  title: Text(tr("tile.licenses")),
                  onTap: () async {
                    PackageInfo info = await PackageInfo.fromPlatform();
                    showLicensePage(
                      context: context,
                      applicationIcon: const Padding(
                        padding: EdgeInsets.all(ConfigConstant.margin2),
                        child: FlutterLogo(
                          size: ConfigConstant.iconSize4,
                        ),
                      ),
                      applicationLegalese: tr(
                        "msg.copyright",
                        namedArgs: {
                          "YEAR": DateTime.now().year.toString(),
                        },
                      ),
                      applicationVersion: "${info.version}+${info.buildNumber}",
                      applicationName: info.appName,
                    );
                  },
                ),
              ]),
              SpSectionContents(
                headline: tr("tile.version"),
                tiles: [
                  buildCheckForUpdateTile(),
                  SpDeveloperVisibility(
                    child: ListTile(
                      leading: const Icon(Icons.developer_mode),
                      title: Text(SpRouter.developerMode.datas.title),
                      onTap: () {
                        Navigator.of(context).pushNamed(SpRouter.developerMode.path);
                      },
                    ),
                  ),
                  ListTile(
                    leading: const SizedBox(height: 40, child: Icon(Icons.rate_review)),
                    title: Text(tr("tile.rate_us")),
                    onTap: () {
                      LaunchReview.launch(iOSAppId: "1629372753");
                    },
                  ),
                  const SpAppVersion(),
                  ConfigConstant.sizedBoxH2,
                  buildCommunity(context),
                ],
              ),
              // SpSectionContents(
              //   headline: null,
              //   tiles: [
              //     ConfigConstant.sizedBoxH2,
              //   ],
              // )
            ],
          )..add(const SizedBox(height: kToolbarHeight)),
        ),
      ),
    );
  }

  Widget buildCommunity(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2).copyWith(top: ConfigConstant.margin0),
            leading: const Padding(padding: EdgeInsets.all(8.0), child: Icon(CommunityMaterialIcons.github)),
            title: Text(tr("tile.report.title")),
            subtitle: Text(tr("tile.report.subtitle")),
            onTap: () {
              AppHelper.openLinkDialog(RemoteConfigStringKeys.linkToGithub.get());
            },
          ),
          SpRemoteConfigEnabler(
            remoteKey: RemoteConfigBooleanKeys.enableFacebookCommunityTile,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2).copyWith(top: ConfigConstant.margin0),
              leading: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.facebook)),
              title: Text(tr("tile.spooky_communtiy.title")),
              subtitle: Text(tr("tile.spooky_communtiy.subtitle")),
              onTap: () {
                openFacebookGroup(context);
              },
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2).copyWith(bottom: ConfigConstant.margin0),
            leading: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.telegram)),
            title: Text(tr("tile.telegram.title")),
            subtitle: Text(tr("tile.telegram.subtitle")),
            onTap: () {
              AppHelper.openLinkDialog(RemoteConfigStringKeys.linkToTelegramChannel.get());
            },
          ),
        ],
      ),
    );
  }

  Future<void> openFacebookGroup(BuildContext context) async {
    String fallbackUrl = RemoteConfigStringKeys.linkToFacebookGroupWeb1.get();
    String fbProtocolUrl = Platform.isIOS
        ? RemoteConfigStringKeys.linkToFacebookGroupDeeplinkIos.get()
        : RemoteConfigStringKeys.linkToFacebookGroupDeeplinkAndroid.get();

    Uri? fbBundleUri = await uriBaseOnDevTool(context, Uri.parse(fbProtocolUrl));
    if (fbBundleUri == null) return;

    bool canLaunchNatively = await canLaunchUrl(fbBundleUri);
    if (context.read<DeveloperModeProvider>().developerModeOn) {
      ToastService.show("Can launch nativel: $canLaunchNatively");
    }

    if (canLaunchNatively) {
      launchUrl(fbBundleUri);
    } else {
      AppHelper.openLinkDialog(fallbackUrl);
    }
  }

  Future<Uri?> uriBaseOnDevTool(BuildContext context, Uri fbBundleUri) async {
    if (context.read<DeveloperModeProvider>().developerModeOn) {
      final uri = await showConfirmationDialog(
        context: context,
        title: "Open via",
        cancelLabel: MaterialLocalizations.of(context).cancelButtonLabel,
        actions: [
          AlertDialogAction(
            label: "IOS (fb://group?id=id)",
            key: RemoteConfigStringKeys.linkToFacebookGroupDeeplinkIos.get(),
          ),
          AlertDialogAction(
            label: "Android (fb://group/:id)",
            key: RemoteConfigStringKeys.linkToFacebookGroupDeeplinkAndroid.get(),
          ),
          AlertDialogAction(
            label: "Web (https://www.fb.com)",
            key: RemoteConfigStringKeys.linkToFacebookGroupWeb1.get(),
          ),
          AlertDialogAction(
            label: "Web (https://m.fb.com)",
            key: RemoteConfigStringKeys.linkToFacebookGroupWeb2.get(),
          ),
        ],
      );
      if (uri != null) return Uri.parse(uri);
      return null;
    } else {
      return fbBundleUri;
    }
  }

  Widget buildCheckForUpdateTile() {
    return Consumer<InAppUpdateProvider>(builder: (context, provider, child) {
      return ListTile(
        leading: SizedBox(
          height: 40,
          child: Icon(
            !provider.isUpdateAvailable ? Icons.system_update : Icons.update,
            color: M3Color.of(context).secondary,
          ),
        ),
        title: Text(provider.isUpdateAvailable ? tr("tile.update_available.title") : tr("tile.check_for_update.title")),
        subtitle:
            provider.isUpdateAvailable && provider.storeVersion != null ? Text(provider.storeVersion ?? "") : null,
        onTap: () async {
          if (!provider.isUpdateAvailable) await provider.load();
          if (provider.isUpdateAvailable) {
            alertUpdate(context, provider);
          } else {
            MessengerService.instance.showSnackBar(tr("alert.no_update_available"));
          }
        },
      );
    });
  }

  Future<void> alertUpdate(BuildContext context, InAppUpdateProvider provider) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: tr("tile.update_available.title"),
      okLabel: tr("button.update"),
      defaultType: OkCancelAlertDefaultType.ok,
      cancelLabel: tr("button.cancel"),
    );
    switch (result) {
      case OkCancelResult.ok:
        await provider.update();
        break;
      case OkCancelResult.cancel:
        break;
    }
  }
}

class CloudStorageTile extends StatelessWidget {
  const CloudStorageTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final destination = GDriveBackupDestination();

    return destination.buildWithConsumer(
      builder: (context, provider, child) {
        return ListTile(
          leading: const SizedBox(
            height: 44,
            child: Icon(Icons.cloud),
          ),
          title: Text(
            SpRouter.cloudStorages.datas.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: provider.shouldAlert
              ? Text(tr("button.backup_now"), style: TextStyle(color: M3Color.of(context).error))
              : null,
          trailing: provider.shouldAlert ? Icon(Icons.warning_rounded, color: M3Color.of(context).error) : null,
          onTap: () {
            Navigator.of(context).pushNamed(SpRouter.cloudStorages.path);
          },
        );
      },
    );
  }
}

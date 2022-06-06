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
        actions: [
          Consumer<InAppUpdateProvider>(builder: (context, provider, child) {
            return SpAnimatedIcons(
              firstChild: SpIconButton(
                icon: const Icon(Icons.system_update),
                onPressed: () => provider.update(),
              ),
              secondChild: const SizedBox.shrink(),
              showFirst: provider.isUpdateAvailable,
            );
          }),
          ConfigConstant.sizedBoxW0
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: kToolbarHeight),
        children: SpSectionsTiles.divide(
          context: context,
          sections: [
            SpSectionContents(
              headline: "User",
              tiles: [
                ListTile(
                  leading: const Icon(Icons.cloud),
                  title: Text(SpRouter.cloudStorage.title),
                  onTap: () {
                    Navigator.of(context).pushNamed(SpRouter.cloudStorage.path);
                  },
                ),
                // ListTile(
                //   leading: const Icon(Icons.person),
                //   title: Text(SpRouter.user.title),
                //   onTap: () {
                //     Navigator.of(context).pushNamed(SpRouter.user.path);
                //   },
                // ),
                ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: Text(SpRouter.themeSetting.title),
                  onTap: () {
                    Navigator.of(context).pushNamed(SpRouter.themeSetting.path);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.archive),
                  title: Text(SpRouter.archive.title),
                  onTap: () {
                    Navigator.of(context).pushNamed(SpRouter.archive.path);
                  },
                ),
              ],
            ),
            SpSectionContents(
              headline: "Features",
              tiles: [
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: Text(SpRouter.security.title),
                  onTap: () {
                    Navigator.of(context).pushNamed(SpRouter.security.path);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text(SpRouter.soundList.title),
                  onTap: () {
                    Navigator.of(context).pushNamed(SpRouter.soundList.path);
                  },
                ),
                ListTile(
                  leading: SizedBox(height: 40, child: Icon(Icons.extension, color: M3Color.of(context).primary)),
                  title: Text(SpRouter.addOn.title),
                  subtitle: Text(SpRouter.addOn.subtitle),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.of(context).pushNamed(SpRouter.addOn.path);
                  },
                ),
              ],
            ),
            SpSectionContents(
              headline: "Info",
              tiles: [
                ListTile(
                  leading: const SizedBox(height: 40, child: Icon(Icons.telegram)),
                  title: const Text('Telegram Channel'),
                  onTap: () {
                    launchUrl(Uri.parse(AppConstant.telegramChannel), mode: LaunchMode.externalApplication);
                  },
                  subtitle: const Text(
                    "News, tutorial, bugs report etc.",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ListTile(
                  leading: const SizedBox(height: 40, child: Icon(Icons.privacy_tip_rounded)),
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    launchUrl(Uri.parse(AppConstant.privacyPolicy), mode: LaunchMode.externalApplication);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.newspaper),
                  title: const Text("Licenses"),
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
                      applicationLegalese: "© ${DateTime.now().year} Juniorise",
                      applicationVersion: "${info.version}+${info.buildNumber}",
                      applicationName: info.appName,
                    );
                  },
                ),
              ],
            ),
            SpSectionContents(
              headline: "Version",
              tiles: [
                buildCheckForUpdateTile(),
                SpDeveloperVisibility(
                  child: ListTile(
                    leading: const Icon(Icons.developer_mode),
                    title: Text(SpRouter.developerMode.title),
                    onTap: () {
                      Navigator.of(context).pushNamed(SpRouter.developerMode.path);
                    },
                  ),
                ),
                ListTile(
                  leading: const SizedBox(height: 40, child: Icon(Icons.rate_review)),
                  title: const Text('Rate us'),
                  onTap: () {
                    LaunchReview.launch();
                  },
                ),
                const SpAppVersion(),
              ],
            ),
          ],
        ),
      ),
    );
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
        title: Text(provider.isUpdateAvailable ? 'Update available' : 'Check for update'),
        subtitle: provider.isUpdateAvailable && provider.updateInfo?.availableVersionCode != null
            ? Text(provider.updateInfo!.availableVersionCode!.toString())
            : null,
        onTap: () async {
          if (provider.isUpdateAvailable) {
            await provider.update();
          } else {
            await provider.load();
            if (provider.isUpdateAvailable) {
              final result = await showOkAlertDialog(
                context: context,
                title: "Update available",
                okLabel: "Update",
              );
              switch (result) {
                case OkCancelResult.ok:
                  await provider.update();
                  break;
                case OkCancelResult.cancel:
                  break;
              }
            } else {
              MessengerService.instance.showSnackBar("No update available");
            }
          }
        },
      );
    });
  }
}

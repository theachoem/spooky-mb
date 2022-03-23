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
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text("Licenses"),
                  onTap: () async {
                    PackageInfo info = await PackageInfo.fromPlatform();
                    about.showLicensePage(
                      context: context,
                      applicationIcon: const Padding(
                        padding: EdgeInsets.all(ConfigConstant.margin2),
                        child: FlutterLogo(
                          size: ConfigConstant.iconSize4,
                        ),
                      ),
                      applicationLegalese: "© ${DateTime.now().year} Juniorise",
                      applicationVersion: info.version + "+" + info.buildNumber,
                      applicationName: info.appName,
                    );
                  },
                ),
                const SpAppVersion(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

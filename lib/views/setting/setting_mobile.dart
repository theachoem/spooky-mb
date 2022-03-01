part of setting_view;

class _SettingMobile extends StatelessWidget {
  final SettingViewModel viewModel;
  const _SettingMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Setting",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: kToolbarHeight),
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            SpDeveloperVisibility(
              child: ListTile(
                leading: const Icon(Icons.developer_mode),
                title: const Text("Developer"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeveloperModeView()));
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Security"),
              onTap: () {
                Navigator.of(context).pushNamed(SpRouteConfig.security);
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text("Archive"),
              onTap: () {
                Navigator.of(context).pushNamed(SpRouteConfig.archive);
              },
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text("Theme"),
              onTap: () {
                Navigator.of(context).pushNamed(SpRouteConfig.themeSetting);
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text("Licenses"),
              onTap: () async {
                PackageInfo info = await PackageInfo.fromPlatform();
                about.showLicensePage(
                  context: context,
                  applicationIcon: Padding(
                    padding: const EdgeInsets.all(ConfigConstant.margin2),
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
            SpAppVersion(),
          ],
        ).toList(),
      ),
    );
  }

  Widget buildTestColor(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: List.generate(
          M3Color.dayColorsOf(context).length,
          (index) {
            Color? color = M3Color.dayColorsOf(context)[index + 1];
            return SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 8,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: ConfigConstant.circlarRadius1),
                  title: Text(
                    DateFormatHelper.toDay().format(DateTime(2020, 1, index - 1)),
                    style: TextStyle(color: M3Color.of(context).onPrimary),
                  ),
                  onTap: () => context.read<ColorSeedProvider>().updateColor(color),
                  tileColor: color,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

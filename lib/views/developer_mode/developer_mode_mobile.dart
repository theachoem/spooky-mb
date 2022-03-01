part of developer_mode_view;

class _DeveloperModeMobile extends StatelessWidget {
  final DeveloperModeViewModel viewModel;
  const _DeveloperModeMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: SpPopButton(),
        title: Text(
          "Developer",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            Consumer<NicknameProvider>(
              builder: (context, provider, child) {
                return ListTile(
                  title: Text("Reset Nickname"),
                  subtitle: Text(provider.name?.isNotEmpty == true ? provider.name! : "Empty"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    provider.clearNickname();
                    MessengerService.instance.showSnackBar("Cleared");
                  },
                );
              },
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Flexible(
                    child: ListTile(
                      title: Text("Restart App"),
                      subtitle: Text("Flutter Level"),
                      onTap: () => Phoenix.rebirth(context),
                    ),
                  ),
                  VerticalDivider(width: 0),
                  Flexible(
                    child: ListTile(
                      title: Text("Restart App"),
                      subtitle: Text("Native Level"),
                      onTap: () => Restart.restartApp(),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                PackageInfo? info = snapshot.data;
                return ListTile(
                  title: Text("Package Infos"),
                  subtitle: info != null ? Text(info.version) : null,
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    showOkAlertDialog(
                      context: context,
                      message: AppHelper.prettifyJson({
                        "appName": info?.appName,
                        "packageName": info?.packageName,
                        "version": info?.version,
                        "buildNumber": info?.buildNumber,
                        "buildSignature": info?.buildSignature,
                      }).trim(),
                    );
                  },
                );
              },
            ),
          ],
        ).toList(),
      ),
    );
  }
}

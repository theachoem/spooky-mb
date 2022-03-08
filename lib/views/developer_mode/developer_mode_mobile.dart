part of developer_mode_view;

class _DeveloperModeMobile extends StatelessWidget {
  final DeveloperModeViewModel viewModel;
  const _DeveloperModeMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: const SpPopButton(),
        title: const SpAppBarTitle(),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            Consumer<NicknameProvider>(
              builder: (context, provider, child) {
                return ListTile(
                  title: const Text("Reset Nickname"),
                  subtitle: Text(provider.name?.isNotEmpty == true ? provider.name! : "Empty"),
                  trailing: const Icon(Icons.keyboard_arrow_right),
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
                      title: const Text("Restart App"),
                      subtitle: const Text("Flutter Level"),
                      onTap: () => Phoenix.rebirth(context),
                    ),
                  ),
                  const VerticalDivider(width: 0),
                  Flexible(
                    child: ListTile(
                      title: const Text("Restart App"),
                      subtitle: const Text("Native Level"),
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
                  title: const Text("Package Infos"),
                  subtitle: info != null ? Text(info.version) : null,
                  trailing: const Icon(Icons.keyboard_arrow_right),
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

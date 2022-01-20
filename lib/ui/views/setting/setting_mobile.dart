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
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text("Archive"),
              onTap: () {
                context.router.push(route.Archive());
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text("Licenses"),
              onTap: () {
                context.router.pushWidget(LicensePage());
              },
            ),
          ],
        ).toList(),
      ),
    );
  }
}

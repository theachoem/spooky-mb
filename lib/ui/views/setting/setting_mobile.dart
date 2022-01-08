part of setting_view;

class _SettingMobile extends StatelessWidget {
  final SettingViewModel viewModel;
  const _SettingMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
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
              leading: Icon(Icons.folder),
              title: Text("File Explorer"),
              onTap: () {
                context.router.push(
                  route.FileManager(directory: FileHelper.directory),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.archive),
              title: Text("Archive"),
              onTap: () {
                context.router.push(route.Archive());
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text("Licenses"),
              onTap: () {
                context.router.push(route.LicensePage());
              },
            ),
          ],
        ).toList(),
      ),
    );
  }
}

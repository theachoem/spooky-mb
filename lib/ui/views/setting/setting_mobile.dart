part of setting_view;

class _SettingMobile extends StatelessWidget {
  final SettingViewModel viewModel;
  const _SettingMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
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
                  r.FileManager(directory: FileHelper.directory),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text("Licenses"),
              onTap: () {
                context.router.push(r.LicensePage());
              },
            )
          ],
        ).toList(),
      ),
    );
  }
}

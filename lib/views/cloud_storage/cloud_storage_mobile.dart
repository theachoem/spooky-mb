part of cloud_storage_view;

class _CloudStorageMobile extends StatelessWidget {
  final CloudStorageViewModel viewModel;
  const _CloudStorageMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: SpPopButton(),
        title: Text(
          "Cloud Storage",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: ListView(
        children: SpSectionsTiles.divide(
          context: context,
          sections: [
            SpSectionContents(
              headline: "Cloud Service",
              tiles: [
                ListTile(
                  title: Text(viewModel.googleUser?.email ?? "Connect with Google Drive"),
                  subtitle: viewModel.googleUser?.displayName != null ? Text(viewModel.googleUser!.displayName!) : null,
                  leading: CircleAvatar(child: Icon(CommunityMaterialIcons.google_drive)),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    if (viewModel.googleUser != null) {
                      DeveloperModeProvider provider = Provider.of<DeveloperModeProvider>(context, listen: false);
                      if (provider.developerModeOn) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return _CloudFileList();
                        }));
                      }
                    } else {
                      viewModel.signInWithGoogle();
                    }
                  },
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(CommunityMaterialIcons.restore)),
                  title: Text("View Backups"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return RestoreView();
                        },
                      ),
                    );
                  },
                )
              ],
            ),
            if (viewModel.years != null) buildYearsSection(context),
          ],
        ),
      ),
    );
  }

  SpSectionContents buildYearsSection(BuildContext context) {
    return SpSectionContents(
      headline: "Years",
      tiles: viewModel.years!.map((e) {
        Set<int> loadingYears = viewModel.loadingYears;
        return ListTile(
          title: Text(e.year.toString()),
          onTap: e.synced ? null : () => viewModel.backup(e.year),
          trailing: SpAnimatedIcons(
            showFirst: e.synced,
            firstChild: Icon(Icons.check, color: M3Color.of(context).primary),
            secondChild: SpAnimatedIcons(
              showFirst: !loadingYears.contains(e.year),
              firstChild: Icon(Icons.backup),
              secondChild: CircularProgressIndicator.adaptive(),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CloudFileList extends StatefulWidget {
  const _CloudFileList({Key? key}) : super(key: key);

  @override
  State<_CloudFileList> createState() => _CloudFileListState();
}

class _CloudFileListState extends State<_CloudFileList> {
  BaseCloudStorage cloudStorage = GDriveStorage();
  CloudFileListModel? files;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    CloudFileListModel? result = await cloudStorage.execHandler(() async {
      return cloudStorage.list({
        "next_token": files?.nextToken,
      });
    });
    setState(() => files = result);
  }

  Future<void> delete(CloudFileModel file) async {
    await cloudStorage.execHandler(() async {
      return cloudStorage.delete({'file_id': file.id});
    });
    await load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: SpPopButton(),
        title: Text(
          "Drive Storage",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: files != null ? buildFileList(files: files!) : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildFileList({required CloudFileListModel files}) {
    if (files.files.isEmpty) {
      return Center(
        child: Text("Empty"),
      );
    }

    return ListView.builder(
      physics: ScrollPhysics(),
      itemCount: files.files.length,
      itemBuilder: (context, index) {
        CloudFileModel file = files.files[index];
        BackupDisplayModel display = BackupDisplayModel.fromCloudModel(file);

        return ListTile(
          title: Text(display.fileName),
          subtitle: display.displayCreateAt != null ? Text("Created at " + display.displayCreateAt!) : null,
          trailing: SpIconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              delete(file);
            },
          ),
        );
      },
    );
  }
}

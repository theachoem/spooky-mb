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
                GoogleAccountTile(
                  onSignOut: () {
                    viewModel.load();
                  },
                  onSignIn: () {
                    viewModel.load();
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
          trailing: SpCrossFade(
            showFirst: e.synced,
            firstChild: Text("Synced"),
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

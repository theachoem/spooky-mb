part of cloud_storage_view;

class _CloudStorageMobile extends StatelessWidget {
  final CloudStorageViewModel viewModel;
  const _CloudStorageMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: const SpPopButton(),
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
                  leading: const CircleAvatar(child: Icon(CommunityMaterialIcons.restore)),
                  title: const Text("View Backups"),
                  onTap: () {
                    Navigator.of(context).pushNamed(SpRouter.restore.path);
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
            alignment: Alignment.bottomRight,
            firstChild: Text("Synced"),
            secondChild: SpAnimatedIcons(
              showFirst: !loadingYears.contains(e.year),
              firstChild: const Icon(Icons.backup),
              secondChild: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: const CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

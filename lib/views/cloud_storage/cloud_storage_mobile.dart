part of cloud_storage_view;

class _CloudStorageMobile extends StatelessWidget {
  final CloudStorageViewModel viewModel;
  const _CloudStorageMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    bool isNotEmpty = viewModel.years?.isNotEmpty == true;
    return Scaffold(
      appBar: MorphingAppBar(
        leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
        title: const SpAppBarTitle(fallbackRouter: SpRouter.cloudStorage),
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
                const StoryPadBackupTile(),
                ListTile(
                  leading: const CircleAvatar(child: Icon(CommunityMaterialIcons.restore)),
                  title: const Text("View Backups"),
                  onTap: () {
                    Navigator.of(context).pushNamed(SpRouter.restore.path);
                  },
                ),
              ],
            ),
            if (isNotEmpty) buildYearsSection(context),
            if (!isNotEmpty) SpSectionContents(headline: "No stories to backup", tiles: []),
          ],
        ),
      ),
    );
  }

  SpSectionContents buildYearsSection(BuildContext context) {
    List<YearCloudModel>? years = viewModel.years;
    years?.sort((a, b) => a.year > b.year ? -1 : 1);
    return SpSectionContents(
      headline: "Years",
      tiles: [
        Wrap(
          children: years!.map((e) {
            Set<int> loadingYears = viewModel.loadingYears;
            return LayoutBuilder(builder: (context, constraint) {
              return SizedBox(
                width: constraint.maxWidth / 2,
                child: ListTile(
                  title: Text(e.year.toString()),
                  onTap: e.synced ? null : () => viewModel.backup(e.year),
                  leading: SpCrossFade(
                    showFirst: e.synced,
                    alignment: Alignment.bottomRight,
                    firstChild: Icon(
                      Icons.check_circle,
                      color: M3Color.dayColorsOf(context)[4],
                    ),
                    secondChild: SpAnimatedIcons(
                      showFirst: !loadingYears.contains(e.year),
                      firstChild: const Icon(Icons.backup),
                      secondChild: LoopAnimation<int>(
                        builder: (context, child, value) {
                          return Transform.rotate(
                            angle: value * pi / 180,
                            child: const Icon(Icons.sync),
                          );
                        },
                        tween: IntTween(begin: 0, end: 180),
                      ),
                    ),
                  ),
                ),
              );
            });
          }).toList(),
        )
      ],
    );
  }
}

part of restore_view;

class _RestoreMobile extends StatelessWidget {
  final RestoreViewModel viewModel;
  const _RestoreMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildAppBar(context),
          SliverList(
            delegate: SliverChildListDelegate(SpSectionsTiles.divide(
              showTopDivider: true,
              context: context,
              sections: [
                SpSectionContents(
                  headline: "Cloud Service",
                  tiles: [
                    ListTile(
                      title: Text(viewModel.googleUser?.email ?? "Google Drive"),
                      subtitle: Text(viewModel.googleUser?.displayName ?? "Connect to restore backups"),
                      leading: CircleAvatar(child: Icon(CommunityMaterialIcons.google_drive)),
                      trailing: SpAnimatedIcons(
                        showFirst: viewModel.googleUser != null,
                        firstChild: Icon(Icons.check),
                        secondChild: Icon(Icons.login),
                      ),
                      onTap: () async {
                        if (viewModel.googleUser == null) {
                          viewModel.signInWithGoogle();
                        }
                      },
                    ),
                  ],
                ),
                if (viewModel.fileList != null)
                  SpSectionContents(
                    headline: "Backups",
                    tiles: viewModel.fileList?.files.map(
                          (e) {
                            BackupDisplayModel display = BackupDisplayModel.fromCloudModel(e);
                            return ListTile(
                              title: Text(display.fileName),
                              subtitle: display.displayCreateAt != null
                                  ? Text("Created at " + display.displayCreateAt!)
                                  : null,
                              onTap: () {
                                viewModel.restore(context, e);
                              },
                            );
                          },
                        ).toList() ??
                        [],
                  )
              ],
            )),
          ),
        ],
      ),
    );
  }

  MorphingSliverAppBar buildAppBar(BuildContext context) {
    return MorphingSliverAppBar(
      expandedHeight: 200,
      backgroundColor: M3Color.of(context).background,
      leading: SpPopButton(),
      floating: true,
      stretch: true,
      title: Text(""),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: TweenAnimationBuilder<int>(
          duration: ConfigConstant.fadeDuration,
          tween: IntTween(begin: 0, end: 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 56.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Backup",
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                  textAlign: TextAlign.center,
                ),
                ConfigConstant.sizedBoxH1,
                Text(
                  "Connect with a Cloud Storage to restore your data",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          builder: (context, value, child) {
            return AnimatedOpacity(
              opacity: value == 1 ? 1.0 : 0.0,
              duration: ConfigConstant.fadeDuration,
              child: child,
            );
          },
        ),
      ),
      actions: [
        SpButton(
          label: "Skip",
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).appBarTheme.titleTextStyle?.color,
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(SpRouteConfig.main, (_) => false);
          },
        ),
      ],
    );
  }
}

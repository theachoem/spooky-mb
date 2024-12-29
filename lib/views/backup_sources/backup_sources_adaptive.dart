part of 'backup_sources_view.dart';

class _BackupSourcesAdaptive extends StatelessWidget {
  const _BackupSourcesAdaptive(this.viewModel);

  final BackupSourcesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackupSourcesProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => viewModel.onPopInvokedWithResult(didPop, result, context),
      child: Scaffold(
        appBar: AppBar(title: const Text("Backups")),
        body: buildBody(provider),
      ),
    );
  }

  Widget buildBody(BackupSourcesProvider provider) {
    if (provider.loading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    return ListView.separated(
      itemCount: provider.backupSources.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final source = provider.backupSources[index];
        return buildSourceTile(context, source, provider);
      },
    );
  }

  Widget buildSourceTile(BuildContext context, BaseBackupSource source, BackupSourcesProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.add_to_drive,
              size: 24.0,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Google Drive",
                  style: TextTheme.of(context).titleMedium,
                ),
                if (source.lastSyncedAt != null) ...[
                  RichText(
                    text: TextSpan(
                      style: TextTheme.of(context).bodyMedium,
                      text: DateFormatService.yMEd_jms(source.lastSyncedAt!),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Container(
                            margin: const EdgeInsets.only(left: 4.0),
                            child: Icon(
                              Icons.check,
                              color: ColorScheme.of(context).primary,
                              size: 16.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
                const SizedBox(height: 8.0),
                Container(
                  transform: Matrix4.identity()..translate(-4.0, 0.0),
                  child: Wrap(
                    spacing: 4.0,
                    children: [
                      if (source.isSignedIn == true)
                        FilledButton(
                          onPressed: viewModel.disabledActions
                              ? null
                              : provider.canBackup(source)
                                  ? () => viewModel.call(() => provider.backup(source))
                                  : null,
                          child: const Text("Backup"),
                        ),
                      if (source.isSignedIn == true)
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(foregroundColor: ColorScheme.of(context).error),
                          onPressed:
                              viewModel.disabledActions ? null : () => viewModel.call(() => provider.signOut(source)),
                          child: const Text("Sign out"),
                        ),
                      if (source.isSignedIn == false)
                        OutlinedButton(
                          onPressed:
                              viewModel.disabledActions ? null : () => viewModel.call(() => provider.signIn(source)),
                          child: const Text("Sign In"),
                        ),
                      if (source.isSignedIn == true)
                        OutlinedButton.icon(
                          label: const Text("View Backups"),
                          icon: const Icon(Icons.cloud),
                          onPressed: viewModel.disabledActions
                              ? null
                              : () {
                                  ShowBackupSourceRoute(source: source).push(context);
                                },
                        ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

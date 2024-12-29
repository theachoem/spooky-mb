part of 'backup_sources_view.dart';

class _BackupSourcesAdaptive extends StatelessWidget {
  const _BackupSourcesAdaptive(this.viewModel);

  final BackupSourcesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackupSourcesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Backups")),
      body: buildBody(provider),
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
        return buildSourceTile(context, source);
      },
    );
  }

  Widget buildSourceTile(BuildContext context, BaseBackupSource source) {
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
                RichText(
                  text: TextSpan(
                    style: TextTheme.of(context).bodyMedium,
                    children: [
                      const TextSpan(text: "Learn more how it store "),
                      WidgetSpan(
                        child: Icon(Icons.info, size: 16.0, color: Theme.of(context).colorScheme.primary),
                        alignment: PlaceholderAlignment.middle,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 4.0,
                  children: [
                    if (source.isSignedIn == true)
                      Container(
                        transform: Matrix4.identity()..translate(-4.0, 0.0),
                        child: FilledButton(
                          onPressed: () => source.backup(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Backup",
                                style: TextTheme.of(context)
                                    .labelMedium
                                    ?.copyWith(color: ColorScheme.of(context).onPrimary),
                              ),
                              if (source.synced == true)
                                Text(
                                  "4/12/24 12:32PM",
                                  style: TextTheme.of(context)
                                      .bodySmall
                                      ?.copyWith(color: ColorScheme.of(context).onPrimary),
                                ),
                            ],
                          ),
                        ),
                      ),
                    if (source.isSignedIn == true)
                      Container(
                        transform: Matrix4.identity()..translate(-4.0, 0.0),
                        child: OutlinedButton(
                          child: const Text("Sign out"),
                          onPressed: () => source.signOut(),
                        ),
                      ),
                    if (source.isSignedIn == false)
                      Container(
                        transform: Matrix4.identity()..translate(-4.0, 0.0),
                        child: OutlinedButton(
                          child: const Text("Sign In"),
                          onPressed: () => source.signIn(),
                        ),
                      ),
                    if (source.isSignedIn == true)
                      Container(
                        transform: Matrix4.identity()..translate(-4.0, 0.0),
                        child: OutlinedButton.icon(
                          label: const Text("View Backups"),
                          icon: const Icon(Icons.cloud),
                          onPressed: () {
                            ShowBackupSourceRoute(source: source).push(context);
                          },
                        ),
                      ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

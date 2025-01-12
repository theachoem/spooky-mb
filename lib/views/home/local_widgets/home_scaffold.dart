part of '../home_view.dart';

class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold({
    required this.endDrawer,
    required this.viewModel,
    required this.appBar,
    required this.body,
    required this.floatingActionButton,
  });

  final HomeViewModel viewModel;
  final Widget? endDrawer;
  final Widget appBar;
  final Widget body;
  final Widget floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          const StoryListTimelineVerticleDivider(),
          ListViewObserver(
            controller: viewModel.scrollInfo.observerScrollController,
            onObserve: (result) => viewModel.scrollInfo.onObserve(result, context),
            child: RefreshIndicator.adaptive(
              edgeOffset: viewModel.scrollInfo.appBar(context).getExpandedHeight() + MediaQuery.of(context).padding.top,
              onRefresh: () async {
                await viewModel.load();
                if (context.mounted) await context.read<BackupProvider>().syncBackupAcrossDevices();
              },
              child: CustomScrollView(
                controller: viewModel.scrollInfo.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  appBar,
                  buildSyncingStatus(context),
                  body,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter buildSyncingStatus(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<BackupProvider>(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
          decoration: BoxDecoration(color: ColorScheme.of(context).readOnly.surface5),
          child: Text(
            "Syncing to Google Drive...",
            style: TextTheme.of(context).bodySmall?.copyWith(color: ColorScheme.of(context).onSurface),
            textAlign: TextAlign.center,
          ),
        ),
        builder: (context, provider, child) {
          return SpCrossFade(
            showFirst: provider.syncing,
            firstChild: child!,
            secondChild: const SizedBox(width: double.infinity),
          );
        },
      ),
    );
  }
}

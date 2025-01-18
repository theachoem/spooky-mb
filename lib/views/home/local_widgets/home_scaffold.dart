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
          RefreshIndicator.adaptive(
            edgeOffset: viewModel.scrollInfo.appBar(context).getExpandedHeight() + MediaQuery.of(context).padding.top,
            onRefresh: () => refresh(context),
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
        ],
      ),
    );
  }

  Future<void> refresh(BuildContext context) async {
    await viewModel.load(debugSource: '$runtimeType#refresh');
    if (context.mounted) await context.read<BackupProvider>().syncBackupAcrossDevices();
  }

  SliverToBoxAdapter buildSyncingStatus(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<BackupProvider>(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          decoration: BoxDecoration(color: ColorScheme.of(context).bootstrap.success.color),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Synced to Google Drive ",
              style:
                  TextTheme.of(context).bodySmall?.copyWith(color: ColorScheme.of(context).bootstrap.success.onColor),
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.cloud_done,
                    size: 16.0,
                    color: ColorScheme.of(context).bootstrap.success.onColor,
                  ),
                  alignment: PlaceholderAlignment.middle,
                ),
              ],
            ),
          ),
        ),
        builder: (context, provider, child) {
          return SpCountDown(
            endTime: provider.lastSyncExecutionAt?.add(const Duration(seconds: 3)) ??
                DateTime.now().subtract(const Duration(days: 1)),
            endWidget: child!,
            builder: (ended, endWidget) {
              return SpCrossFade(
                showFirst: !ended,
                firstChild: endWidget,
                secondChild: const SizedBox(width: double.infinity),
              );
            },
          );
        },
      ),
    );
  }
}

part of 'home_view.dart';

class _HomeAdaptive extends StatelessWidget {
  const _HomeAdaptive(this.viewModel);

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: viewModel.stories?.items.isNotEmpty == true ? buildStories() : const Text("No data"),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.goToNewPage(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildStories() {
    return ListView.builder(
      itemCount: viewModel.stories?.items.length ?? 0,
      itemBuilder: (context, index) {
        final story = viewModel.stories!.items[index];
        final lastChange = story.changes.lastOrNull;
        final displayBody = lastChange != null ? viewModel.getDisplayBodyFor(lastChange) : null;

        return ListTile(
          title: Text(lastChange?.title ?? 'N/A'),
          subtitle: displayBody != null ? Text(displayBody) : null,
          onTap: () => viewModel.goToViewPage(context, story),
        );
      },
    );
  }
}

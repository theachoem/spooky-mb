part of 'home_view.dart';

class _HomeAdaptive extends StatelessWidget {
  const _HomeAdaptive(this.viewModel);

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: viewModel.stories?.items.isNotEmpty == true ? buildStories() : const Text("No data"),
    );
  }

  Widget buildStories() {
    return ListView.builder(
      itemCount: viewModel.stories?.items.length ?? 0,
      itemBuilder: (context, index) {
        final story = viewModel.stories!.items[index];
        return ListTile(
          title: Text(story.changes.lastOrNull?.title ?? 'N/A'),
          subtitle: Text(story.changes.lastOrNull?.plainText ?? 'N/A'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return StoryDetailsView(id: story.id);
            }));
          },
        );
      },
    );
  }
}

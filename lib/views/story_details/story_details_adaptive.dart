part of 'story_details_view.dart';

class _StoryDetailsAdaptive extends StatelessWidget {
  const _StoryDetailsAdaptive(this.viewModel);

  final StoryDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.story?.createdAt.toString() ?? 'NA'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(viewModel.story?.displayPathDate.toString() ?? 'N/A'),
          Text(
            viewModel.tags?.items
                    .where((t) => viewModel.story?.tags?.contains(t.id.toString()) == true)
                    .map((e) => e.title)
                    .join(", ") ??
                'N/A',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        viewModel.save();
      }),
    );
  }
}

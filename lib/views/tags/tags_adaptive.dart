part of 'tags_view.dart';

class _TagsAdaptive extends StatelessWidget {
  const _TagsAdaptive(this.viewModel);

  final TagsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tags"),
      ),
    );
  }
}

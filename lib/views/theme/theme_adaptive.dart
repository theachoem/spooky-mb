part of 'theme_view.dart';

class _ThemeAdaptive extends StatelessWidget {
  const _ThemeAdaptive(this.viewModel);

  final ThemeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme"),
      ),
    );
  }
}

part of 'home_view.dart';

class _HomeAdaptive extends StatelessWidget {
  const _HomeAdaptive(this.viewModel);

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return const ListTile();
        },
      ),
    );
  }
}

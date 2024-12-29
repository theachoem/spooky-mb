part of '../home_view.dart';

class _HomeEmpty extends StatelessWidget {
  const _HomeEmpty({
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 200),
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + kToolbarHeight),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextTheme.of(context).bodyLarge,
              children: [
                const TextSpan(text: 'Please click on'),
                const WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.edit,
                      size: 16.0,
                    ),
                  ),
                  alignment: PlaceholderAlignment.middle,
                ),
                TextSpan(text: 'to add story to ${viewModel.year}'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

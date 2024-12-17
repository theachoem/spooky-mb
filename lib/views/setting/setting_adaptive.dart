part of 'setting_view.dart';

class _SettingAdaptive extends StatelessWidget {
  const _SettingAdaptive(this.viewModel);

  final SettingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting')),
    );
  }
}

part of file_viewer_view;

class _FileViewerMobile extends StatelessWidget {
  final FileViewerViewModel viewModel;
  const _FileViewerMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: Text(FileHelper.fileName(viewModel.file.path)),
      ),
      body: Padding(
        padding: ConfigConstant.layoutPadding,
        child: SelectableText(
          viewModel.fileContent ?? "",
          style: M3TextTheme.of(context).bodyMedium,
        ),
      ),
    );
  }
}

part of 'show_backup_source_view.dart';

class _ShowBackupSourceAdaptive extends StatelessWidget {
  const _ShowBackupSourceAdaptive(this.viewModel);

  final ShowBackupSourceViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => viewModel.onPopInvokedWithResult(didPop, result, context),
      child: Scaffold(
        appBar: AppBar(),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    if (viewModel.cloudFiles == null) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    if (viewModel.cloudFiles?.files.isEmpty == true) {
      return const Center(
        child: Text("Empty"),
      );
    }

    return ListView.builder(
      itemCount: viewModel.cloudFiles?.files.length ?? 0,
      itemBuilder: (context, index) {
        CloudFileObject cloudFile = viewModel.cloudFiles!.files[index];
        BackupFileObject? fileInfo = cloudFile.getFileInfo();

        return ListTile(
          onTap: () => viewModel.openBackup(context, cloudFile),
          title: Text(fileInfo?.device.model ?? 'N/A'),
          subtitle: Text(DateFormatService.yMEd_jmsNullable(fileInfo?.createdAt) ?? 'N/A'),
          contentPadding: const EdgeInsets.only(left: 16.0, right: 8.0),
          trailing: IconButton(
            color: ColorScheme.of(context).error,
            icon: const Icon(Icons.delete),
            onPressed: viewModel.disabledActions ? null : () => viewModel.delete(cloudFile, context),
          ),
        );
      },
    );
  }
}

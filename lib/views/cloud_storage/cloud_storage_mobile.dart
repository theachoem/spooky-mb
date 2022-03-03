part of cloud_storage_view;

class _CloudStorageMobile extends StatelessWidget {
  final CloudStorageViewModel viewModel;
  const _CloudStorageMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: SpPopButton(),
        title: Text(
          "Developer",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: viewModel.files != null
          ? buildFileList(files: viewModel.files!)
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildFileList({required CloudFileListModel files}) {
    return ListView.builder(
      itemCount: files.files.length,
      itemBuilder: (context, index) {
        CloudFileModel file = files.files[index];
        return ListTile(
          title: Text(file.description ?? file.fileName ?? file.id),
          trailing: SpIconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              viewModel.delete(file);
            },
          ),
        );
      },
    );
  }
}

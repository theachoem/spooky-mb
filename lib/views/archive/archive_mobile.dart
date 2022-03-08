part of archive_view;

class _ArchiveMobile extends StatelessWidget {
  final ArchiveViewModel viewModel;
  const _ArchiveMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: const SpAppBarTitle(),
        leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
      ),
      body: StoryQueryList(
        queryOptions: StoryQueryOptionsModel(filePath: FilePathType.archive),
        onListReloaderReady: (loader) {},
        onDelete: (StoryModel story) async {
          OkCancelResult result = await showOkCancelAlertDialog(
            context: context,
            title: "Are you sure to delete?",
            message: "You can't undo this action",
            okLabel: "Delete",
            isDestructiveAction: true,
          );
          switch (result) {
            case OkCancelResult.ok:
              bool success = await viewModel.delete(story);
              String message = success ? "Delete successfully!" : "Delete unsuccessfully!";
              MessengerService.instance.showSnackBar(message);
              return success;
            case OkCancelResult.cancel:
              return false;
          }
        },
        onUnarchive: (StoryModel story) async {
          String? message = DateFormatHelper.yM().format(story.path.toDateTime());

          OkCancelResult result = await showOkCancelAlertDialog(
            context: context,
            title: "Are you sure to unarchive?",
            message: "Document will be move to:\n" + message,
            okLabel: "Unarchive",
          );

          switch (result) {
            case OkCancelResult.ok:
              bool success = await viewModel.unarchiveDocument(story);
              String message = success ? "Unarchive successfully!" : "Unarchive unsuccessfully!";
              MessengerService.instance.showSnackBar(message);
              return success;
            case OkCancelResult.cancel:
              return false;
          }
        },
      ),
    );
  }
}

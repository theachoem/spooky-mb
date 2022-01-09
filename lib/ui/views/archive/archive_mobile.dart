part of archive_view;

class _ArchiveMobile extends StatelessWidget {
  final ArchiveViewModel viewModel;
  const _ArchiveMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: Text(
          'Archive',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
      ),
      body: StoryList(
        onRefresh: () => viewModel.load(),
        stories: viewModel.stories,
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
              App.of(context)?.showSpSnackBar(success ? "Delete successfully!" : "Delete unsuccessfully!");
              return success;
            case OkCancelResult.cancel:
              return false;
          }
        },
        onUnarchive: (StoryModel story) async {
          String? message;
          if (story.pathDate != null || story.createdAt != null) {
            message = DateFormatHelper.yM().format(story.pathDate ?? story.createdAt!);
          }

          OkCancelResult result = await showOkCancelAlertDialog(
            context: context,
            title: "Are you sure to unarchive?",
            message: message != null ? "Document will be move to:\n" + message : null,
            okLabel: "Unarchive",
          );

          switch (result) {
            case OkCancelResult.ok:
              bool success = await viewModel.unarchiveDocument(story);
              App.of(context)?.showSpSnackBar(success ? "Unarchive successfully!" : "Unarchive unsuccessfully!");
              return success;
            case OkCancelResult.cancel:
              return false;
          }
        },
      ),
    );
  }
}

part of manage_pages_view;

class _ManagePagesMobile extends StatelessWidget {
  final ManagePagesViewModel viewModel;
  const _ManagePagesMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => onWillPop(context),
      child: Scaffold(
        appBar: MorphingAppBar(
          heroTag: DetailView.appBarHeroKey,
          leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
          title: const SpAppBarTitle(fallbackRouter: SpRouter.managePages),
          actions: buildActionsButton(context),
        ),
        body: buildPagesList(),
      ),
    );
  }

  Future<bool> onWillPop(BuildContext context) async {
    if (viewModel.hasChangeNotifier.value) {
      OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: tr("alert.discard_changes.title"),
        message: tr("alert.discard_changes.message"),
        isDestructiveAction: false,
        barrierDismissible: true,
      );
      switch (result) {
        case OkCancelResult.ok:
          return true;
        case OkCancelResult.cancel:
          return false;
      }
    }
    return true;
  }

  List<Widget> buildActionsButton(BuildContext context) {
    return [
      ValueListenableBuilder(
        valueListenable: viewModel.hasChangeNotifier,
        builder: (context, value, child) {
          return SpAnimatedIcons(
            showFirst: viewModel.hasChangeNotifier.value,
            firstChild: Center(
              key: const ValueKey(Icons.refresh_outlined),
              child: SpIconButton(
                icon: const Icon(Icons.refresh_outlined),
                onPressed: () => viewModel.reload(),
              ),
            ),
            secondChild: const SizedBox.shrink(key: ValueKey("SizeBox")),
          );
        },
      ),
      ValueListenableBuilder(
        valueListenable: viewModel.hasChangeNotifier,
        builder: (context, value, child) {
          return SpAnimatedIcons(
            firstChild: Center(
              key: const ValueKey(Icons.save),
              child: SpIconButton(
                icon: const Icon(Icons.save),
                onPressed: () async {
                  bool hasDeleteSomePage = viewModel.content.pages?.length != viewModel.documents.length;
                  OkCancelResult result = await showOkCancelAlertDialog(
                    context: context,
                    title: tr("alert.sure_to_save_changes.title"),
                    message: hasDeleteSomePage ? tr("alert.sure_to_save_changes.message") : null,
                    barrierDismissible: true,
                    isDestructiveAction: hasDeleteSomePage,
                    okLabel: MaterialLocalizations.of(context).saveButtonLabel.toLowerCase().capitalize,
                  );
                  switch (result) {
                    case OkCancelResult.ok:
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        Navigator.of(context).pop(viewModel.save());
                      });
                      break;
                    case OkCancelResult.cancel:
                      break;
                  }
                },
              ),
            ),
            secondChild: const SizedBox.shrink(key: ValueKey("SizeBox")),
            showFirst: viewModel.hasChangeNotifier.value,
          );
        },
      ),
    ];
  }

  Widget buildPagesList() {
    return ReorderableListView.builder(
      itemCount: viewModel.documents.length,
      onReorder: viewModel.reordered,
      itemBuilder: (context, index) {
        DocumentKeyModel? item = AppHelper.listItem(viewModel.documents, index);
        if (item == null) return SizedBox.shrink(key: ValueKey(item?.key));
        return buildDimssiableItem(
          item: item,
          context: context,
          index: index,
          child: buildChild(item),
        );
      },
    );
  }

  Widget buildChild(DocumentKeyModel item) {
    String text = item.document.toPlainText().trim();
    return Column(
      children: [
        ListTile(
          title: Text(item.key.toString()),
          subtitle: text.isEmpty ? null : Text(text, maxLines: 1),
          trailing: const Icon(Icons.reorder),
        ),
        const Divider(height: 0)
      ],
    );
  }

  Widget buildDimssiableItem({
    required DocumentKeyModel item,
    required BuildContext context,
    required int index,
    required Widget child,
  }) {
    return Dismissible(
      key: ValueKey(item.key),
      secondaryBackground: SpDimissableBackground(
        alignment: Alignment.centerRight,
        backgroundColor: M3Color.of(context).error,
        foregroundColor: M3Color.of(context).onError,
        iconData: Icons.delete,
        iconSize: ConfigConstant.iconSize2,
        shouldAnimatedIcon: false,
      ),
      onDismissed: (direction) => viewModel.updateUnfinishState(),
      background: SpDimissableBackground(
        alignment: Alignment.centerLeft,
        backgroundColor: M3Color.of(context).error,
        foregroundColor: M3Color.of(context).onError,
        iconData: Icons.delete,
        iconSize: ConfigConstant.iconSize2,
        shouldAnimatedIcon: false,
      ),
      confirmDismiss: (direction) async {
        bool success = viewModel.deleteAt(index);
        if (!success) MessengerService.instance.showSnackBar(tr("alert.page_at_least_1.title"));
        return success;
      },
      child: child,
    );
  }
}

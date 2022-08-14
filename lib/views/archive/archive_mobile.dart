part of archive_view;

class _ArchiveMobile extends StatelessWidget {
  final ArchiveViewModel viewModel;
  const _ArchiveMobile(this.viewModel);

  List<PathType> get pathTypes => viewModel.pathTypes;
  PathType get selectedPathType => viewModel.selectedPathType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: SpPopupMenuButton(
          dyGetter: (dy) => dy + 48,
          dxGetter: (dx) => dx - 16.0,
          items: (context) {
            return pathTypes.map((e) {
              return SpPopMenuItem(
                title: TypeLocalization.pathType(e),
                trailingIconData: e == selectedPathType ? Icons.check : null,
                onPressed: () {
                  viewModel.setPathType(e);
                },
              );
            }).toList();
          },
          builder: (callback) {
            return SpTapEffect(
              onTap: callback,
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                  text: TypeLocalization.pathType(selectedPathType),
                  children: const [
                    WidgetSpan(
                      child: Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
      ),
      body: IndexedStack(
        index: viewModel.pathTypes.indexOf(selectedPathType),
        children: viewModel.pathTypes.map((e) {
          bool selected = e == selectedPathType;
          return AnimatedOpacity(
            opacity: selected ? 1.0 : 0.0,
            duration: ConfigConstant.duration,
            child: AnimatedContainer(
              duration: ConfigConstant.duration,
              transform: Matrix4.identity()..translate(0.0, !selected ? 8.0 : 0.0),
              child: StoryQueryList(queryOptions: StoryQueryOptionsModel(type: e)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

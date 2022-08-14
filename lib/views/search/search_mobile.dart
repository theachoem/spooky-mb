part of search_view;

class _SearchMobile extends StatelessWidget {
  final SearchViewModel viewModel;
  const _SearchMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return SearchScaffold(
      initialQuery: viewModel.query,
      titleBuilder: (setQuery) {
        return viewModel.displayTag != null
            ? SpAppBarTitle(
                fallbackRouter: SpRouter.search,
                overridedTitle: viewModel.displayTag,
              )
            : TextField(
                textInputAction: TextInputAction.search,
                style: Theme.of(context).appBarTheme.titleTextStyle,
                decoration: InputDecoration(
                  hintText: tr("field.search.hint_text"),
                  border: InputBorder.none,
                ),
                onSubmitted: (text) {
                  setQuery(text);
                },
              );
      },
      resultBuilder: (query) {
        return StoryQueryList(
          queryOptions: query,
          showLoadingAfterInit: true,
          overridedLayout: SpListLayoutType.timeline,
        );
      },
    );
  }
}

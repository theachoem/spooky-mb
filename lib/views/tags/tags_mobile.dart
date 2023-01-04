part of tags_view;

class _TagsMobile extends StatelessWidget {
  final TagsViewModel viewModel;
  const _TagsMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        heroTag: DetailView.appBarHeroKey,
        title: const SpAppBarTitle(
          fallbackRouter: SpRouter.tags,
        ),
        actions: [
          SpIconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              viewModel.create(context);
            },
          ),
        ],
      ),
      body: ReorderableListView.builder(
        onReorder: (oldIndex, newIndex) => viewModel.reorder(oldIndex, newIndex),
        itemCount: viewModel.tags.length,
        itemBuilder: (context, index) {
          final tag = viewModel.tags[index];
          return buildTile(tag, context);
        },
      ),
    );
  }

  Widget buildTile(TagDbModel tag, BuildContext context) {
    return Slidable(
      key: ValueKey(tag.id),
      endActionPane: buildActionsPane(context, tag),
      child: ListTile(
        leading: const SizedBox(height: 44, child: Icon(CommunityMaterialIcons.drag)),
        title: Text(tag.title),
        subtitle: Text(DateFormatHelper.dateFormat().format(tag.createdAt)),
        trailing: SpIconButton(
          icon: SpCrossFade(
            duration: ConfigConstant.fadeDuration,
            firstChild: Icon(Icons.visibility, color: M3Color.of(context).onBackground),
            secondChild: Icon(Icons.visibility_off, color: Theme.of(context).disabledColor),
            showFirst: tag.starred == true,
          ),
          onPressed: () {
            viewModel.toggleStarred(tag);
          },
        ),
        onTap: () {
          Navigator.of(context).pushNamed(
            SpRouter.search.path,
            arguments: SearchArgs(
              displayTag: tag.title,
              initialQuery: StoryQueryOptionsModel(
                tag: tag.id.toString(),
                type: PathType.docs,
              ),
            ),
          );
        },
      ),
    );
  }

  ActionPane buildActionsPane(
    BuildContext context,
    TagDbModel object,
  ) {
    return ActionPane(
      motion: const StretchMotion(),
      dismissible: null,
      extentRatio: 0.5,
      children: [
        SlidableAction(
          backgroundColor: M3Color.of(context).error,
          foregroundColor: M3Color.of(context).onError,
          icon: Icons.delete,
          label: null,
          onPressed: (_) async {
            viewModel.delete(object, context);
          },
        ),
        SlidableAction(
          backgroundColor: M3Color.of(context).primary,
          foregroundColor: M3Color.of(context).onPrimary,
          icon: Icons.edit,
          label: null,
          onPressed: (_) async {
            viewModel.update(object, context);
          },
        ),
      ],
    );
  }
}

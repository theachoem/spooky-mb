part of file_manager_view;

class _FileManagerMobile extends StatelessWidget {
  final FileManagerViewModel viewModel;
  const _FileManagerMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    bool showFirst = viewModel.layout == FileManagerLayout.grid;
    return Scaffold(
      appBar: MorphingAppBar(
        title: Text(
          viewModel.appBarTitle(),
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: showFirst ? M3Color.of(context).primary : M3Color.of(context).secondary,
        foregroundColor: showFirst ? M3Color.of(context).onPrimary : M3Color.of(context).onSecondary,
        onPressed: () async {
          viewModel.nextLayout();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        label: SpCrossFade(
          firstChild: Text(FileManagerLayout.grid.name.capitalize),
          secondChild: Text(FileManagerLayout.list.name.capitalize),
          showFirst: showFirst,
        ),
        icon: SpAnimatedIcons(
          firstChild: const Icon(Icons.grid_3x3, key: ValueKey(Icons.grid_3x3)),
          secondChild: const Icon(Icons.list, key: ValueKey(Icons.list)),
          showFirst: showFirst,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => viewModel.load(reload: true),
        child: buildLayout(context),
      ),
    );
  }

  Widget buildLayout(BuildContext context) {
    switch (viewModel.layout) {
      case FileManagerLayout.grid:
        return buildGridView(context);
      case FileManagerLayout.list:
        return buildListView(context);
    }
  }

  Widget buildListView(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemCount: viewModel.parents.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        FileSystemEntity item = viewModel.parents[index];
        String? extension = item is File ? item.path.split(".").last : null;

        bool viewAble = item is File && item.path.endsWith(AppConstant.documentExstension);
        return SpPopupMenuButton(
          dx: MediaQuery.of(context).size.width,
          items: [
            SpPopMenuItem(
              title: "View Story",
              onPressed: () {
                onEntityPressed(item, context, extension);
              },
            ),
            SpPopMenuItem(
              title: "View Raw",
              onPressed: () {
                context.router.push(route.FileViewer(file: item as File));
              },
            ),
          ],
          builder: (callback) {
            return ListTile(
              title: buildEntityName(
                item: item,
                extension: extension,
                showLine: false,
              ),
              subtitle: buildEntitySubtitle(item),
              onTap: () {
                if (viewAble) {
                  callback();
                } else {
                  onEntityPressed(item, context, extension);
                }
              },
              trailing: viewAble ? const Icon(Icons.more_vert) : null,
            );
          },
        );
      },
    );
  }

  Widget? buildEntitySubtitle(FileSystemEntity item) {
    if (item is File) {
      String date = DateFormatHelper.dateTimeFormat().format(item.lastModifiedSync());
      return Text("Created at $date");
    }
  }

  Widget buildGridView(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(ConfigConstant.margin2),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: MediaQuery.of(context).size.width / 4,
        childAspectRatio: 1,
        crossAxisSpacing: ConfigConstant.margin0,
        mainAxisSpacing: ConfigConstant.margin0,
      ),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: viewModel.parents.length,
      itemBuilder: (context, index) {
        FileSystemEntity item = viewModel.parents[index];
        String? extension = item is File ? item.path.split(".").last : null;
        return buildFileItem(item, context, extension);
      },
    );
  }

  Future<void> onEntityPressed(FileSystemEntity item, BuildContext context, String? extension) async {
    if (item is! File) {
      context.router.push(route.FileManager(
        directory: Directory(item.absolute.path),
      ));
    } else {
      if (extension == AppConstant.documentExstension) {
        StoryModel? content = await DocsManager().fetchOne(item);
        if (content != null) {
          context.router.push(route.Detail(story: content));
        }
      }
    }
  }

  Widget buildFileItem(FileSystemEntity item, BuildContext context, String? extension) {
    return SpTapEffect(
      onTap: () => onEntityPressed(item, context, extension),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(ConfigConstant.margin2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: M3Color.of(context).primaryContainer,
              borderRadius: BorderRadius.circular(ConfigConstant.radius1),
            ),
            child: Wrap(
              children: [
                Icon(extension != null ? Icons.article : Icons.folder),
                const SizedBox(width: double.infinity, height: ConfigConstant.margin0),
                buildEntityName(item: item, extension: extension),
                if (extension != null) buildExstension(extension),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Text buildExstension(String extension) {
    return Text(
      "." + extension,
      maxLines: 1,
      textAlign: TextAlign.center,
    );
  }

  Stack buildEntityName({
    required FileSystemEntity item,
    required String? extension,
    bool showLine = true,
  }) {
    return Stack(
      children: [
        Text(
          item.path.replaceFirst(viewModel.directory.absolute.path + "/", ""),
          maxLines: extension != null ? 1 : 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (showLine)
          Text(
            "\n\n",
            maxLines: extension != null ? 1 : 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}

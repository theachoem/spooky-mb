part of file_manager_view;

class _FileManagerMobile extends StatelessWidget {
  final FileManagerViewModel viewModel;
  const _FileManagerMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: Text(
          viewModel.appBarTitle(),
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => viewModel.load(reload: true),
        child: GridView.builder(
          padding: const EdgeInsets.all(ConfigConstant.margin2),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.width / 4,
            childAspectRatio: 1,
            crossAxisSpacing: ConfigConstant.margin0,
            mainAxisSpacing: ConfigConstant.margin0,
          ),
          itemCount: viewModel.parents.length,
          itemBuilder: (context, index) {
            FileSystemEntity item = viewModel.parents[index];
            String? extension = item is File ? item.path.split(".").last : null;
            return buildFileItem(item, context, extension);
          },
        ),
      ),
    );
  }

  Widget buildFileItem(FileSystemEntity item, BuildContext context, String? extension) {
    return SpTapEffect(
      onTap: () async {
        if (item is! File) {
          context.router.pushNativeRoute(MaterialPageRoute(builder: (context) {
            return FileManagerView(
              directory: Directory(item.absolute.path),
            );
          }));
        } else {
          if (extension == AppConstant.documentExstension) {
            StoryModel? content = await DocsManager().fetchOne(item);
            if (content != null) {
              context.router.push(r.Detail(story: content));
            }
          }
        }
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(ConfigConstant.margin2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: M3Color.of(context)?.primaryContainer,
              borderRadius: BorderRadius.circular(ConfigConstant.radius1),
            ),
            child: Wrap(
              children: [
                Icon(extension != null ? Icons.article : Icons.folder),
                const SizedBox(width: double.infinity, height: ConfigConstant.margin0),
                buildEntityName(item, extension),
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

  Stack buildEntityName(FileSystemEntity item, String? extension) {
    return Stack(
      children: [
        Text(
          item.path.replaceFirst(viewModel.directory.absolute.path + "/", ""),
          maxLines: extension != null ? 1 : 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          "\n\n",
          maxLines: extension != null ? 1 : 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

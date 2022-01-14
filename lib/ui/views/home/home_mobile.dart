part of home_view;

class _HomeMobile extends StatefulWidget {
  final HomeViewModel viewModel;

  const _HomeMobile(
    this.viewModel, {
    Key? key,
  }) : super(key: key);

  @override
  State<_HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<_HomeMobile> with SingleTickerProviderStateMixin {
  late TabController controller;

  // {
  //   1: reloaderPage1(),
  //   .
  //   .
  //   12: reloaderPage12(),
  // }
  Map<int, void Function()> listReloaderMap = {};

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 12, vsync: this, initialIndex: widget.viewModel.month - 1);
    controller.addListener(() {
      int monthIndex = controller.index + 1;
      widget.viewModel.onTabChange(monthIndex);
      if (listReloaderMap.containsKey(monthIndex)) {
        widget.viewModel.onListReloaderReady(listReloaderMap[monthIndex]!);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: headerSliverBuilder,
        body: SpTabView(
          controller: controller,
          children: List.generate(
            controller.length,
            (index) {
              return StoryQueryList(
                queryOptions: StoryQueryOptionsModel(
                  filePath: FilePathType.docs,
                  year: widget.viewModel.year,
                  month: index + 1,
                ),
                onListReloaderReady: (reloader) {
                  listReloaderMap[index + 1] = reloader;
                },
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> headerSliverBuilder(context, scroll) {
    return [
      buildAppBar(),
    ];
  }

  Widget buildAppBar() {
    // TODO: implement story count
    return HomeAppBar(
      title: "Hello Sothea 📝",
      subtitle: "${widget.viewModel.year} - 10 Stories",
      tabController: controller,
      viewModel: widget.viewModel,
      tabLabels: List.generate(
        12,
        (index) {
          return DateFormatHelper.toNameOfMonth().format(
            DateTime(2020, index + 1),
          );
        },
      ),
    );
  }
}

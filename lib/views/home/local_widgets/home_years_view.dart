import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/views/home/home_view_model.dart';

class HomeYearsView extends StatefulWidget {
  const HomeYearsView({super.key});

  @override
  State<HomeYearsView> createState() => HomeYearsViewState();
}

class HomeYearsViewState extends State<HomeYearsView> {
  Map<int, int>? years;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    years = await StoryDbModel.db.getStoryCountsByYear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    HomeViewModel viewModel = Provider.of<HomeViewModel>(context);
    return Scaffold(
      appBar: AppBar(),
      body: buildBody(viewModel),
    );
  }

  Widget buildBody(HomeViewModel viewModel) {
    if (years == null) return const Center(child: CircularProgressIndicator.adaptive());
    return ListView(
      children: [
        ...buildYearsTiles(viewModel),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FilledButton.icon(
            onPressed: () {},
            label: const Text("Add"),
          ),
        ),
      ],
    );
  }

  List<Widget> buildYearsTiles(HomeViewModel viewModel) {
    return years!.entries.map((entry) {
      bool selected = viewModel.year == entry.key;
      return ListTile(
        onTap: () => viewModel.changeYear(entry.key),
        selected: selected,
        title: Text(entry.key.toString()),
        subtitle: Text(entry.value > 1 ? "${entry.value} stories" : "${entry.value} story"),
        trailing: Visibility(
          visible: selected,
          child: const Icon(Icons.check),
        ),
      );
    }).toList();
  }
}

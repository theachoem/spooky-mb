part of '../tags_view_model.dart';

class _TagForm extends StatelessWidget {
  const _TagForm({
    required this.tags,
    this.initialTag,
  });

  final CollectionDbModel<TagDbModel>? tags;
  final TagDbModel? initialTag;

  List<String> get tagTitles => tags?.items.map((e) => e.title).toList() ?? [];

  bool isTagExist(String title) {
    return tagTitles.map((e) => e.toLowerCase()).contains(title.trim().toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return SpDefaultTextController(
      initialText: initialTag?.title,
      builder: (context, controller) {
        return Form(
          child: Builder(builder: (context) {
            return buildScaffold(controller, context);
          }),
        );
      },
    );
  }

  Widget buildScaffold(TextEditingController controller, BuildContext context) {
    void submit() {
      if (!Form.of(context).validate()) return;
      Navigator.of(context).pop(controller.text);
    }

    return Scaffold(
      appBar: AppBar(title: initialTag != null ? const Text("Edit Tag") : const Text("Add Tag")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'eg. Personal'),
            validator: (value) {
              if (value == null || value.trim().isEmpty == true) return "Required";
              if (isTagExist(value) == true) return 'Tag already Exist';
              return null;
            },
            onFieldSubmitted: (text) => submit(),
          ),
          const SizedBox(height: 16.0),
          FilledButton.icon(
            label: const Text("Save"),
            onPressed: () => submit(),
          )
        ],
      ),
    );
  }
}

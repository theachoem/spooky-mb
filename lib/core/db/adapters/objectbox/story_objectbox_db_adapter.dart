part of 'package:spooky/core/db/databases/story_database.dart';

class _StoryObjectBoxDbAdapter extends BaseObjectBoxAdapter<StoryObjectBox> with BaseStoryDbExternalActions {
  _StoryObjectBoxDbAdapter(String tableName) : super(tableName);

  @override
  Future<StoryObjectBox> objectConstructor(Map<String, dynamic> json) async {
    StoryDbModel story = StoryDbModel.fromJson(json);
    StoryObjectBox object = StoryObjectBox(
      id: story.id,
      version: story.version,
      type: story.type.name,
      year: story.year,
      month: story.month,
      day: story.day,
      starred: story.starred,
      feeling: story.feeling,
      createdAt: story.createdAt,
      updatedAt: story.updatedAt,
      movedToBinAt: story.movedToBinAt,
      changes: story.changes.map((e) {
        Map<String, dynamic> json = e.toJson();
        String encoded = jsonEncode(json);
        return HtmlCharacterEntities.encode(encoded);
      }).toList(),
    );
    return object;
  }

  @override
  Map<String, dynamic> objectTransformer(StoryObjectBox object) {
    Iterable<PathType> types = PathType.values.where((e) => e.name == object.type);
    return StoryDbModel(
      type: types.isNotEmpty ? types.first : PathType.docs,
      id: object.id,
      starred: object.starred,
      feeling: object.feeling,
      year: object.year,
      month: object.month,
      day: object.day,
      updatedAt: object.updatedAt,
      createdAt: object.createdAt,
      changes: object.changes.map((str) {
        String decoded = HtmlCharacterEntities.decode(str);
        dynamic json = jsonDecode(decoded);
        return StoryContentDbModel.fromJson(json);
      }).toList(),
    ).toJson();
  }

  @override
  Future<Map<String, dynamic>?> fetchAll({
    Map<String, dynamic>? params,
  }) async {
    String? type = params?["type"];
    int? year = params?["year"];
    int? month = params?["month"];
    int? day = params?["day"];

    Condition<StoryObjectBox>? conditions = StoryObjectBox_.id.notNull();

    if (type != null) conditions = conditions.and(StoryObjectBox_.type.equals(type));
    if (year != null) conditions = conditions.and(StoryObjectBox_.year.equals(year));
    if (month != null) conditions = conditions.and(StoryObjectBox_.month.equals(month));
    if (day != null) conditions = conditions.and(StoryObjectBox_.day.equals(day));

    QueryBuilder<StoryObjectBox> queryBuilder = box.query(conditions);
    Query<StoryObjectBox> query = queryBuilder.build();
    List<StoryObjectBox> objects = query.find();

    List<StoryDbModel> docs = [];
    for (StoryObjectBox object in objects) {
      Map<String, dynamic> json = objectTransformer(object);
      StoryDbModel story = StoryDbModel.fromJson(json);
      docs.add(story);
    }

    return {
      "data": docs.map((e) => e.toJson()).toList(),
      "meta": MetaModel().toJson(),
      "links": MetaModel().toJson(),
    };
  }

  @override
  Future<Set<int>?> fetchYears() async {
    QueryBuilder<StoryObjectBox> queryBuilder = box.query();
    return queryBuilder.build().find().map((e) => e.year).toSet();
  }

  @override
  int getDocsCount(int? year) {
    Condition<StoryObjectBox>? conditions = StoryObjectBox_.id.notNull();
    if (year != null) conditions = conditions.and(StoryObjectBox_.year.equals(year));
    QueryBuilder<StoryObjectBox> queryBuilder = box.query(conditions);
    Query<StoryObjectBox> query = queryBuilder.build();
    return query.count();
  }
}

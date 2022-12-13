part of 'package:spooky/core/db/databases/story_database.dart';

class _StoryObjectBoxDbAdapter extends BaseObjectBoxAdapter<StoryObjectBox, StoryDbModel>
    with BaseStoryDbExternalActions {
  _StoryObjectBoxDbAdapter(String tableName) : super(tableName);

  @override
  Future<List<StoryDbModel>> itemsTransformer(List<StoryObjectBox> objects, [Map<String, dynamic>? params]) {
    return compute(_itemsTransformer, {
      'objects': objects,
      'all_changes': params?['all_changes'],
    });
  }

  @override
  Future<StoryObjectBox> objectConstructor(StoryDbModel body, [Map<String, dynamic>? params]) async {
    return compute(_objectConstructor, body);
  }

  @override
  Future<StoryDbModel> objectTransformer(StoryObjectBox object, [Map<String, dynamic>? params]) {
    return compute(_objectTransformer, {
      'object': object,
      'all_changes': params?['all_changes'],
    });
  }

  @override
  QueryBuilder<StoryObjectBox> buildQuery({Map<String, dynamic>? params}) {
    String? keyword = params?["query"];
    String? type = params?["type"];
    int? year = params?["year"];
    int? month = params?["month"];
    int? day = params?["day"];
    String? tag = params?["tag"];
    bool? starred = params?["starred"];
    int? order = params?["order"];
    bool priority = params?["priority"] == true;
    List<int>? selectedYears = params?["selected_years"];
    List<int>? yearsRange = params?["years_range"];

    Condition<StoryObjectBox>? conditions = StoryObjectBox_.id.notNull();

    if (tag != null) conditions = conditions.and(StoryObjectBox_.tags.contains(tag));
    if (starred == true) conditions = conditions.and(StoryObjectBox_.starred.equals(true));
    if (type != null) conditions = conditions.and(StoryObjectBox_.type.equals(type));
    if (year != null) conditions = conditions.and(StoryObjectBox_.year.equals(year));
    if (month != null) conditions = conditions.and(StoryObjectBox_.month.equals(month));
    if (day != null) conditions = conditions.and(StoryObjectBox_.day.equals(day));

    if (keyword != null) {
      conditions = conditions.and(
        StoryObjectBox_.metadata.contains(
          keyword,
          caseSensitive: false,
        ),
      );
    }

    if (yearsRange != null && yearsRange.length == 2) {
      yearsRange.sort();
      conditions = conditions.and(
        StoryObjectBox_.year.between(
          yearsRange[0],
          yearsRange[1],
        ),
      );
    } else if (selectedYears != null) {
      conditions = conditions.and(StoryObjectBox_.year.oneOf(selectedYears));
    }

    QueryBuilder<StoryObjectBox> queryBuilder = box.query(conditions);
    if (priority) queryBuilder.order(StoryObjectBox_.starred, flags: Order.descending);

    queryBuilder
      ..order(StoryObjectBox_.year, flags: order ?? Order.descending)
      ..order(StoryObjectBox_.month, flags: order ?? Order.descending)
      ..order(StoryObjectBox_.day, flags: order ?? Order.descending)
      ..order(StoryObjectBox_.hour, flags: order ?? Order.descending)
      ..order(StoryObjectBox_.minute, flags: order ?? Order.descending);

    return queryBuilder;
  }

  // :all_changes
  @override
  Future<BaseDbListModel<StoryDbModel>> fetchAll({
    Map<String, dynamic>? params,
  }) async {
    params ??= {};

    bool priority = (await PriorityStarredStorage().read() ?? true) == true;
    params['priority'] = priority;

    SortType? sort = await SortTypeStorage().readEnum();
    if (sort == SortType.newToOld) params['order'] = Order.descending;
    if (sort == SortType.oldToNew) params['order'] = 0;

    QueryBuilder<StoryObjectBox> queryBuilder = buildQuery(params: params);
    Query<StoryObjectBox> query = queryBuilder.build();
    List<StoryObjectBox> find = query.find();
    List<StoryObjectBox> objects = await migrate(find);
    List<StoryDbModel> docs = await compute(_itemsTransformer, {
      'objects': objects,
      'all_changes': params['all_changes'],
    });

    return BaseDbListModel(
      items: docs,
      meta: MetaDbModel(),
      links: LinksDbModel(),
    );
  }

  @override
  Future<Set<int>?> fetchYears() async {
    QueryBuilder<StoryObjectBox> queryBuilder = box.query();
    return queryBuilder.build().find().map((e) => e.year).toSet();
  }

  @override
  int getDocsCount(int? year) {
    Condition<StoryObjectBox>? conditions = StoryObjectBox_.id.notNull();

    conditions = conditions.and(StoryObjectBox_.type.equals(PathType.docs.name));
    if (year != null) conditions = conditions.and(StoryObjectBox_.year.equals(year));

    QueryBuilder<StoryObjectBox> queryBuilder = box.query(conditions);
    Query<StoryObjectBox> query = queryBuilder.build();
    return query.count();
  }

  Future<List<StoryObjectBox>> migrate(List<StoryObjectBox> objects) async {
    for (int i = 0; i < objects.length; i++) {
      StoryObjectBox? object = objects[i];
      if (object.metadata == null || object.hour == null || object.minute == null || object.second == null) {
        if (kDebugMode) {
          print([
            "MIGRATE: ${object.id}",
            object.metadata != null ? "no meta" : "",
            "${object.hour}",
            "${object.minute}",
            "${object.second}"
          ].join(" | "));
        }

        await objectTransformer(object).then((value) {
          return set(body: value);
        });

        object = box.get(object.id);
        if (object != null) objects[i] = object;
      }
    }
    return objects;
  }
}

List<StoryDbModel> _itemsTransformer(Map<String, dynamic> map) {
  List<StoryObjectBox> objects = map['objects'];
  bool allChanges = map['all_changes'] ?? false;

  List<StoryDbModel> docs = [];
  for (StoryObjectBox object in objects) {
    StoryDbModel json = _objectTransformer({
      'object': object,
      'all_changes': allChanges,
    });
    docs.add(json);
  }

  return docs;
}

StoryDbModel _objectTransformer(Map<String, dynamic> map) {
  StoryObjectBox object = map['object'];
  bool allChanges = map['all_changes'] ?? false;

  Iterable<PathType> types = PathType.values.where((e) => e.name == object.type);
  return StoryDbModel(
    type: types.isNotEmpty ? types.first : PathType.docs,
    id: object.id,
    starred: object.starred,
    feeling: object.feeling,
    year: object.year,
    month: object.month,
    day: object.day,
    hour: object.hour ?? object.createdAt.hour,
    minute: object.minute ?? object.createdAt.minute,
    second: object.second ?? object.createdAt.second,
    updatedAt: object.updatedAt,
    createdAt: object.createdAt,
    tags: object.tags,
    rawChanges: object.changes,
    changes: StoryDbConstructorHelper.strsToChanges(
      // set only last & load everything on story tile instead.
      !allChanges && object.changes.isNotEmpty ? [object.changes.last] : object.changes,
    ),
  );
}

StoryObjectBox _objectConstructor(StoryDbModel story) {
  StoryObjectBox object = StoryObjectBox(
    id: story.id,
    version: story.version,
    type: story.type.name,
    year: story.year,
    month: story.month,
    day: story.day,
    hour: story.hour ?? story.createdAt.hour,
    minute: story.minute ?? story.createdAt.minute,
    second: story.second ?? story.createdAt.second,
    tags: story.tags,
    starred: story.starred,
    feeling: story.feeling,
    createdAt: story.createdAt,
    updatedAt: story.updatedAt,
    movedToBinAt: story.movedToBinAt,
    metadata: story.changes.isNotEmpty ? story.changes.last.safeMetadata : "",
    changes: StoryDbConstructorHelper.storyToRawChanges(story),
    eventId: null,
  );
  return object;
}

import 'package:objectbox/objectbox.dart';

@Entity()
class StoryObjectBox {
  @Id(assignable: true)
  int id;
  int version;
  String type;

  int year;
  int month;
  int day;
  int? hour;
  int? minute;
  int? second;

  bool? starred;
  String? feeling;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  @Property(type: PropertyType.date)
  DateTime? movedToBinAt;

  List<String> changes;
  List<String>? tags;

  // for query
  String? metadata;

  StoryObjectBox({
    required this.id,
    required this.version,
    required this.type,
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
    required this.starred,
    required this.feeling,
    required this.createdAt,
    required this.updatedAt,
    required this.movedToBinAt,
    required this.changes,
    required this.tags,
    required this.metadata,
  });
}

@Entity()
class TagObjectBox {
  @Id(assignable: true)
  int id;
  String title;

  int? index;
  int version;
  bool? starred;
  String? emoji;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  TagObjectBox({
    required this.id,
    required this.title,
    required this.index,
    required this.version,
    required this.starred,
    required this.emoji,
    required this.createdAt,
    required this.updatedAt,
  });
}

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

  // relation with EventObjectBox.
  int? eventId;

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
    required this.eventId,
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

@Entity()
class BillObjectBox {
  @Id(assignable: true)
  int id;

  // Write code to generate our own cron base on UI:
  // Then, use this package to parse &
  // check wether now is able to execute cron
  // https://pub.dev/packages/cron
  String? cron;

  @Property(type: PropertyType.date)
  DateTime? startAt;

  @Property(type: PropertyType.date)
  DateTime? finishAt;

  bool autoAddTranaction;

  String? title;
  int? lastTransactionId;
  int categoryId;

  // This column depend
  // on transactions
  double? totalExpense;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime? updatedAt;

  BillObjectBox({
    required this.id,
    required this.cron,
    required this.startAt,
    required this.finishAt,
    required this.title,
    required this.categoryId,
    required this.lastTransactionId,
    required this.autoAddTranaction,
    required this.totalExpense,
    required this.createdAt,
    required this.updatedAt,
  });
}

@Entity()
class EventObjectBox {
  @Id(assignable: true)
  int id;

  // Budget plan, base on USD currency
  double? budget;

  String? title;
  int? lastTransactionId;

  // This column depend
  // on transactions
  double totalExpense;

  @Property(type: PropertyType.date)
  DateTime? startAt;

  @Property(type: PropertyType.date)
  DateTime? finishAt;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime? updatedAt;

  EventObjectBox({
    required this.id,
    required this.budget,
    required this.title,
    required this.lastTransactionId,
    required this.totalExpense,
    required this.startAt,
    required this.finishAt,
    required this.createdAt,
    required this.updatedAt,
  });
}

@Entity()
class TransactionObjectBox {
  @Id(assignable: true)
  int id;

  int day;
  int month;
  int year;

  // 0, 1, 2, 4
  // morning, noon, evening, night
  int? time;

  // If those day, month, year, times
  // are not satisfies user,
  // use this instead
  @Property(type: PropertyType.date)
  DateTime? specificDate;

  String? note;

  int? eventId;
  int? billingId;
  int categoryId;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime? updatedAt;

  TransactionObjectBox({
    required this.id,
    required this.day,
    required this.month,
    required this.year,
    required this.time,
    required this.specificDate,
    required this.note,
    required this.eventId,
    required this.billingId,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });
}

@Entity()
class CategoryObjectBox {
  @Id(assignable: true)
  int id;

  // income, expense
  int position;
  String type;
  String name;
  double? budget;

  // Let user search depend on:
  // https://logo.clearbit.com/netflix.com?size=100x100
  String? icon;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime? updatedAt;

  CategoryObjectBox({
    required this.id,
    required this.position,
    required this.type,
    required this.name,
    required this.budget,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });
}

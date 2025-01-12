abstract class BaseDbModel {
  int get id;
  DateTime? get updatedAt;

  Map<String, dynamic> toJson();
}

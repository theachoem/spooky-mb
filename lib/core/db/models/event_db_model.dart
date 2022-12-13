import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';

part 'event_db_model.g.dart';

@JsonSerializable()
@CopyWith()
class EventDbModel extends BaseDbModel {
  final int id;
  final double? budget;
  final String? title;
  final int? lastTransactionId;
  final double totalExpense;
  final DateTime? startAt;
  final DateTime? finishAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  EventDbModel({
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

  @override
  Map<String, dynamic> toJson() => _$EventDbModelToJson(this);
  factory EventDbModel.fromJson(Map<String, dynamic> json) => _$EventDbModelFromJson(json);
}

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';

part 'transaction_db_model.g.dart';

@JsonSerializable()
@CopyWith()
class TransactionDbModel extends BaseDbModel {
  final int id;
  final int day;
  final int month;
  final int year;
  final int? time;
  final DateTime? specificDate;
  final String? note;
  final int? eventId;
  final int? billingId;
  final int categoryId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TransactionDbModel({
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

  @override
  Map<String, dynamic> toJson() => _$TransactionDbModelToJson(this);
  factory TransactionDbModel.fromJson(Map<String, dynamic> json) => _$TransactionDbModelFromJson(json);
}

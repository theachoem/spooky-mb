import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';

part 'bill_db_model.g.dart';

@JsonSerializable()
@CopyWith()
class BillDbModel extends BaseDbModel {
  final int id;
  final String? cron;
  final DateTime? startAt;
  final DateTime? finishAt;
  final bool autoAddTranaction;
  final String? title;
  final int? lastTransactionId;
  final int categoryId;
  final double? totalExpense;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BillDbModel({
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

  @override
  Map<String, dynamic> toJson() => _$BillDbModelToJson(this);
  factory BillDbModel.fromJson(Map<String, dynamic> json) => _$BillDbModelFromJson(json);
}

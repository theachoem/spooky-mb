import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/backups/models/backups_metadata.dart';
import 'package:spooky/core/models/base_model.dart';

part 'backups_model.g.dart';

@JsonSerializable()
class BackupsModel extends BaseModel {
  final Map<String, dynamic> tables;
  final BackupsMetadata metaData;

  BackupsModel({
    required this.tables,
    required this.metaData,
  });

  static BackupsModel? fromFileName({
    required String fileName,
    required Map<String, dynamic> tables,
  }) {
    BackupsMetadata? metaData = BackupsMetadata.fromFileName(fileName);
    if (metaData == null) return null;
    return BackupsModel(
      metaData: metaData,
      tables: tables,
    );
  }

  @override
  Map<String, dynamic> toJson() => _$BackupsModelToJson(this);
  factory BackupsModel.fromJson(Map<String, dynamic> json) => _$BackupsModelFromJson(json);

  @override
  String? get objectId => metaData.fileName;
}

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';

part 'backups_metadata.g.dart';

@JsonSerializable()
class BackupsMetadata {
  static const String prefix = "Backup";
  static const String splitBy = "::";

  final String deviceModel;
  final String deviceId;
  final DateTime createdAt;
  final String version;

  String get displayCreatedAt {
    return DateFormatHelper.dateTimeFormat().format(createdAt);
  }

  BackupsMetadata({
    this.version = "1",
    required this.deviceModel,
    required this.deviceId,
    required this.createdAt,
  });

  String get fileNameWithExt {
    return "$fileName.json";
  }

  // v1: Backup::v1::2022-06-14T17:44:47.097469::Pixel 5.json
  String get fileName {
    return <String>[
      prefix,
      version,
      createdAt.millisecondsSinceEpoch.toString(),
      deviceModel,
      deviceId,
    ].join(splitBy);
  }

  static BackupsMetadata? fromFileName(String fileName) {
    if (fileName.endsWith(".json")) fileName = fileName.replaceAll(".json", "");
    List<String> value = fileName.split(splitBy);
    if (value.isNotEmpty) {
      String version = value[1];
      switch (version) {
        case "1":
          try {
            int millisecondsEpoch = int.parse(value[2]);
            DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(millisecondsEpoch);
            String deviceModel = value[3];
            String deviceId = value[4];
            return BackupsMetadata(
              createdAt: createdAt,
              deviceModel: deviceModel,
              deviceId: deviceId,
              version: version,
            );
          } catch (e) {
            if (kDebugMode) {
              print("ERROR: fromFileName $e");
            }
          }
          break;
        default:
          return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() => _$BackupsMetadataToJson(this);
  factory BackupsMetadata.fromJson(Map<String, dynamic> json) => _$BackupsMetadataFromJson(json);
}

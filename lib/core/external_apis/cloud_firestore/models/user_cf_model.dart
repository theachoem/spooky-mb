import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/base_model.dart';

part 'user_cf_model.g.dart';

// Cf = CloudFirestore
@JsonSerializable()
@CopyWith()
class UserCfModel extends BaseModel {
  // if this null, we set rule in firestore to be able to deleted,
  // otherwise, user has no permission
  final String? uid;
  UserCfModel({
    this.uid,
  });

  @override
  Map<String, dynamic> toJson() => _$UserCfModelToJson(this);
  factory UserCfModel.fromJson(Map<String, dynamic> json) {
    return _$UserCfModelFromJson(json);
  }

  @override
  String? get objectId => uid ?? "";
}

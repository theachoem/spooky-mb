import 'package:json_annotation/json_annotation.dart';

part 'user_object.g.dart';

@JsonSerializable()
class UserObject {
  final String? nickname;

  UserObject({
    required this.nickname,
  });

  UserObject copyWith({
    String? nickname,
  }) {
    return UserObject(
      nickname: nickname ?? this.nickname,
    );
  }

  Map<String, dynamic> toJson() => _$UserObjectToJson(this);
  factory UserObject.fromJson(Map<String, dynamic> json) => _$UserObjectFromJson(json);
}

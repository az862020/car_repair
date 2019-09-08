import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'UserInfo.g.dart';

@JsonSerializable()
class UserInfo {
  final String uid;
  final String photoUrl;
  final String displayName;
  final String sex;
  final String signature;

  UserInfo(this.uid, this.photoUrl, this.displayName,
      {this.sex, this.signature});

  //json
  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

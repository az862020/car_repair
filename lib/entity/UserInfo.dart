import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'UserInfo.g.dart';

@JsonSerializable()
class UserInfo{
  final String uid;
  final String photoUrl;
  final String displayName;

  UserInfo(this.uid, this.photoUrl, this.displayName);

  //json
  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

}
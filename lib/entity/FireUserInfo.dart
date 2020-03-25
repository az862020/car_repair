import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'FireUserInfo.g.dart';

@JsonSerializable()
class FireUserInfo {
  String uid;
  final String photoUrl;
  final String displayName;
  String sex;
  String signature;

  FireUserInfo(this.uid, this.photoUrl, this.displayName,
      {this.sex, this.signature});

  //json
  factory FireUserInfo.fromJson(Map<String, dynamic> json) =>
      _$FireUserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FireUserInfoToJson(this);
}

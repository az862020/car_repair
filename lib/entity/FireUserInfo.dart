import 'package:json_annotation/json_annotation.dart';

part 'FireUserInfo.g.dart';

@JsonSerializable()
class FireUserInfo {
  String uid;
  final String photoUrl;
  final String displayName;
  String sex;
  String signature;
  bool chat;
  bool map;
  bool square;

  FireUserInfo(this.uid, this.photoUrl, this.displayName,
      {this.sex, this.signature, this.chat, this.map, this.square});

  //json
  factory FireUserInfo.fromJson(Map<String, dynamic> json) =>
      _$FireUserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FireUserInfoToJson(this);
}

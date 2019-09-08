// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(json['uid'] as String, json['photoUrl'] as String,
      json['displayName'] as String,
      sex: json['sex'] as String, signature: json['signature'] as String);
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'uid': instance.uid,
      'photoUrl': instance.photoUrl,
      'displayName': instance.displayName,
      'sex': instance.sex,
      'signature': instance.signature
    };

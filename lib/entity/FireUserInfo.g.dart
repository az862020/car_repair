// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FireUserInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FireUserInfo _$FireUserInfoFromJson(Map<String, dynamic> json) {
  var userinfo = FireUserInfo(json['uid'] as String,
      json['photoUrl'] as String,
      json['displayName'] as String);
  if(json.containsKey('sex')) userinfo.sex = json['sex'];
  if(json.containsKey('signature')) userinfo.sex = json['signature'];
  if(json.containsKey('chat')) userinfo.sex = json['chat'];
  if(json.containsKey('map')) userinfo.sex = json['map'];
  if(json.containsKey('square')) userinfo.sex = json['square'];
  return userinfo;
}

Map<String, dynamic> _$FireUserInfoToJson(FireUserInfo instance) {
  var map = <String, dynamic>{
    'uid': instance.uid,
    'photoUrl': instance.photoUrl,
    'displayName': instance.displayName,
  };
  if (instance.sex != null) map['sex'] = instance.sex;
  if (instance.signature != null) map['signature'] = instance.signature;
  map['chat'] = instance.chat??false;
  map['map'] = instance.map??false;
  map['square'] = instance.square??true;
  return map;
}



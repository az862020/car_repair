// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Square.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Square _$SquareFromJson(Map<String, dynamic> json) {
  var square = Square(
    json['title'] as String,
    json['note'] as String,
    json['userID'] as String,
  );
  if (json.containsKey('id')) square.id = json['id'] as String;
  if (json.containsKey('favorate')) square.favorate = json['favorate'] as int;
  if (json.containsKey('click')) square.click = json['click'] as int;
  if (json.containsKey('comment')) square.comment = json['comment'] as int;
  if (json.containsKey('date')) square.date = json['date'] as int;
  if (json.containsKey('video')) square.video = json['video'];
  if (json.containsKey('pics'))
    square.pics = (json['pics'] as List)?.map((e) => e as String)?.toList();
  return square;
}

Map<String, dynamic> _$SquareToJson(Square instance) {
  var map = <String, dynamic>{
    'title': instance.title,
    'note': instance.note,
    'userID': instance.userID,
  };
  if (instance.id != null) map['id'] = instance.id;
  map['click'] = (instance.click??0);
  map['favorate'] = instance.favorate??0;
  map['comment'] = instance.comment??0;
  map['date'] = instance.date??0;
  if (instance.video != null) map['video'] = instance.video;
  if (instance.pics != null) map['pics'] = instance.pics;
  return map;
}

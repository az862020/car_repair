// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Square.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Square _$SquareFromJson(Map<String, dynamic> json) {
  var square = Square(
    json['favorate'] == null
        ? (BigInt.from(0))
        : BigInt.parse(json['favorate'] as String),
    json['title'] as String,
    json['note'] as String,
  );
  if (json.containsKey('id')) square.id = json['id'];
  if (json.containsKey('video')) square.video = json['video'];
  if (json.containsKey('pics'))
    square.pics = (json['pics'] as List)?.map((e) => e as String)?.toList();
  return square;
}

Map<String, dynamic> _$SquareToJson(Square instance) {
  var map = <String, dynamic>{
    'favorate': instance.favorate?.toString(),
    'title': instance.title,
    'note': instance.note,
  };
  if (instance.id != null) map['id'] = instance.id;
  if (instance.video != null) map['video'] = instance.video;
  if (instance.pics != null) map['pics'] = instance.pics;
  return map;
}

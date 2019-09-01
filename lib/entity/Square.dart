import 'package:json_annotation/json_annotation.dart';

part 'Square.g.dart';

@JsonSerializable()
class Square {
  final String id;
  final BigInt favorate;
  final String title;
  final String note;
  final String video;
  final List<String> pics;

  Square(this.favorate, this.title, this.note, this.video, this.pics,
      {this.id});

  factory Square.fromJson(Map<String, dynamic> json) => _$SquareFromJson(json);

  Map<String, dynamic> toJson() => _$SquareToJson(this);

  @override
  String toString() {
    return 'Square{ ${id ?? ''}, favorate:$favorate, title:$title, note:$note, video:$video, pics:$pics} ';
  }
}

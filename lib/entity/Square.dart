import 'package:json_annotation/json_annotation.dart';

part 'Square.g.dart';

@JsonSerializable()
class Square {
  String id;
  int click = 0;
  int comment = 0;
  int favorate = 0;
  final String title;
  final String note;
  final String userID;
  String type;
  String video;
  List<String> pics;
  int date;

  Square(this.title, this.note, this.userID,
      {this.video, this.pics, this.id, this.favorate, this.click, this.comment, this.date, this.type});

  factory Square.fromJson(Map<String, dynamic> json) => _$SquareFromJson(json);

  Map<String, dynamic> toJson() => _$SquareToJson(this);

  @override
  String toString() {
    return 'Square{ ${id ?? ''}, favorate:$favorate, title:$title, note:$note, video:$video, pics:$pics, click:$click, comment:$comment} ';
  }
}

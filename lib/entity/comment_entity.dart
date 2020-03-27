import 'package:car_repair/generated/json/base/json_convert_content.dart';

class CommentEntity with JsonConvert<CommentEntity> {
	String id;
	String userID;
	String content;
	int time;

	CommentEntity({this.userID, this.content, this.time});


}

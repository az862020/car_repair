import 'package:car_repair/entity/comment_entity.dart';

commentEntityFromJson(CommentEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['time'] != null) {
		data.time = json['time']?.toInt();
	}
	if (json['userID'] != null) {
		data.userID = json['userID']?.toString();
	}
	if (json['content'] != null) {
		data.content = json['content']?.toString();
	}
	return data;
}

Map<String, dynamic> commentEntityToJson(CommentEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['time'] = entity.time;
	data['userID'] = entity.userID;
	data['content'] = entity.content;
	return data;
}
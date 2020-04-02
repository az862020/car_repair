import 'package:car_repair/entity/fire_message_entity.dart';

fireMessageEntityFromJson(FireMessageEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['sendID'] != null) {
		data.sendID = json['sendID']?.toString();
	}
	if (json['time'] != null) {
		data.time = json['time']?.toInt();
	}
	if (json['type'] != null) {
		data.type = json['type']?.toInt();
	}
	if (json['content'] != null) {
		data.content = json['content']?.toString();
	}
	return data;
}

Map<String, dynamic> fireMessageEntityToJson(FireMessageEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['sendID'] = entity.sendID;
	data['time'] = entity.time;
	data['type'] = entity.type;
	data['content'] = entity.content;
	return data;
}
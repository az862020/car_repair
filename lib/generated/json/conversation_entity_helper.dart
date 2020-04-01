import 'package:car_repair/entity/conversation_entity.dart';

conversationEntityFromJson(ConversationEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['chattype'] != null) {
		data.chattype = json['chattype']?.toInt();
	}
	if (json['updateTime'] != null) {
		data.updateTime = json['updateTime']?.toInt();
	}
	if (json['user'] != null) {
		data.user = json['user']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['content'] != null) {
		data.content = json['content']?.toString();
	}
	if (json['displayName'] != null) {
		data.displayName = json['displayName']?.toString();
	}
	if (json['photoUrl'] != null) {
		data.photoUrl = json['photoUrl']?.toString();
	}
	return data;
}

Map<String, dynamic> conversationEntityToJson(ConversationEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['chattype'] = entity.chattype;
	data['updateTime'] = entity.updateTime;
	data['user'] = entity.user;
	data['content'] = entity.content;
	data['displayName'] = entity.displayName;
	data['photoUrl'] = entity.photoUrl;
	return data;
}
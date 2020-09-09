import 'package:car_repair/entity/fire_user_info_entity.dart';

fireUserInfoEntityFromJson(FireUserInfoEntity data, Map<String, dynamic> json) {
	if (json['uid'] != null) {
		data.uid = json['uid']?.toString();
	}
	if (json['photoUrl'] != null) {
		data.photoUrl = json['photoUrl']?.toString();
	}
	if (json['displayName'] != null) {
		data.displayName = json['displayName']?.toString();
	}
	if (json['sex'] != null) {
		data.sex = json['sex']?.toString();
	}
	if (json['signature'] != null) {
		data.signature = json['signature']?.toString();
	}
	if (json['backgroundPhoto'] != null) {
		data.backgroundPhoto = json['backgroundPhoto']?.toString();
	}
	if (json['country'] != null) {
		data.country = json['country']?.toString();
	}
	if (json['province'] != null) {
		data.province = json['province']?.toString();
	}
	if (json['chat'] != null) {
		data.chat = json['chat'];
	}
	if (json['map'] != null) {
		data.map = json['map'];
	}
	if (json['square'] != null) {
		data.square = json['square'];
	}
	if (json['friends'] != null) {
		data.friends = json['friends'];
	}
	return data;
}

Map<String, dynamic> fireUserInfoEntityToJson(FireUserInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['uid'] = entity.uid;
	data['photoUrl'] = entity.photoUrl;
	data['displayName'] = entity.displayName;
	data['sex'] = entity.sex;
	data['signature'] = entity.signature;
	data['backgroundPhoto'] = entity.backgroundPhoto;
	data['country'] = entity.country;
	data['province'] = entity.province;
	data['chat'] = entity.chat;
	data['map'] = entity.map;
	data['square'] = entity.square;
	data['friends'] = entity.friends;
	return data;
}
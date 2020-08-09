import 'package:car_repair/entity/user_infor_entity.dart';

userInforEntityFromJson(UserInforEntity data, Map<String, dynamic> json) {
	if (json['photoUrl'] != null) {
		data.photoUrl = json['photoUrl']?.toString();
	}
	if (json['uid'] != null) {
		data.uid = json['uid']?.toString();
	}
	if (json['isBlack'] != null) {
		data.isBlack = json['isBlack']?.toInt();
	}
	if (json['displayName'] != null) {
		data.displayName = json['displayName']?.toString();
	}
	if (json['isFriend'] != null) {
		data.isFriend = json['isFriend']?.toInt();
	}
	if (json['remarkName'] != null) {
		data.remarkName = json['remarkName']?.toString();
	}
	return data;
}

Map<String, dynamic> userInforEntityToJson(UserInforEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['photoUrl'] = entity.photoUrl;
	data['uid'] = entity.uid;
	data['isBlack'] = entity.isBlack;
	data['displayName'] = entity.displayName;
	data['isFriend'] = entity.isFriend;
	data['remarkName'] = entity.remarkName;
	return data;
}
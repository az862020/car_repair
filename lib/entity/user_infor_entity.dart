import 'package:car_repair/generated/json/base/json_convert_content.dart';

class UserInforEntity with JsonConvert<UserInforEntity> {
	String photoUrl;
	String uid;
	bool isBlack;
	String displayName;
	bool isFriend;
	String remarkName;
}

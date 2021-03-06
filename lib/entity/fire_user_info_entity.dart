import 'package:car_repair/generated/json/base/json_convert_content.dart';

class FireUserInfoEntity with JsonConvert<FireUserInfoEntity> {
	String uid;
	String photoUrl;
	String displayName;
	String sex;
	String signature;
	String backgroundPhoto;
	String country;
	String province;
	bool chat;
	bool map;
	bool square;
	bool friends;
}

import 'package:car_repair/generated/json/base/json_convert_content.dart';

class FireMessageEntity with JsonConvert<FireMessageEntity> {
	String id;
	String sendID;
	String targetID;
	int time;
	int type;
	String content;
}

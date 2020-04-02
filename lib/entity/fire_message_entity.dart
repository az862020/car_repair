import 'package:car_repair/generated/json/base/json_convert_content.dart';

class FireMessageEntity with JsonConvert<FireMessageEntity> {
	String id;
	String sendID;
	int time;
	int type;
	String content;
}

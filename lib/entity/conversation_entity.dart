import 'package:car_repair/generated/json/base/json_convert_content.dart';

class ConversationEntity with JsonConvert<ConversationEntity> {
	String id;
	int chattype;//type 0 = private; type 1 = group;
	int updateTime;
	List<String> user;
	String content;//display in conversation list;
	String displayName;
	String photoUrl;
}

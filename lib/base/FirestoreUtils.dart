import 'package:car_repair/base/Config.dart';
import 'package:car_repair/entity/Square.dart';
import 'package:car_repair/entity/comment_entity.dart';
import 'package:car_repair/entity/conversation_entity.dart';
import 'package:car_repair/entity/fire_message_entity.dart';
import 'package:car_repair/entity/fire_user_info_entity.dart';
import 'package:car_repair/entity/user_infor_entity.dart';
import 'package:car_repair/generated/json/conversation_entity_helper.dart';
import 'package:car_repair/generated/json/user_infor_entity_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_utils/common_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// FireStore 远程数据库.带基础搜索功能.
/// 区分 Userinfo 和 Square.
/// 需要一套 增删改查.
class FireStoreUtils {
  static String STORE_USERINFO = 'userinfo'; //用户信息数据位置
  static String STORE_SQUARE = 'square'; //广场记录的数据位置
  static String STORE_COMMENTS = '/comments'; //广场记录的评论的数据位置
  static String STORE_PUBISH = 'publishList'; //广场记录的评论的数据位置
  static String STORE_FAVORATE = 'favorate'; //广场记录的评论的数据位置
  static String STORE_RELATIONSHIP = 'relationship'; //用户的关系网
  static String STORE_CONVERSATION = 'conversation'; //会话数据位置

  static final int PHOTOURL = 0; //头像
  static final int DISPLAYName = 1; //昵称
  static final int SIX = 2; //性别
  static final int SIGNATURE = 3; //签名
  static final int BACKGROUND = 4; //头像背景
  static final int CHAT = 5; //是否显示聊天

  static const int isBlack = 1; //是拉黑状态
  static const int isFriend = 1; //是好友
//  static final int isFriendRequest = 2; //好友申请状态
//  static final int isBeFriendRequest = 3; //被好友申请状态

  static final keys = [
    'photoUrl',
    'displayName',
    'sex',
    'signature',
    'background',
    'chat'
  ];

  static getUserlistDocumentReferenece(String type) {
    String path = '$STORE_USERINFO/${Config.user.uid}/list';
    var collectionReference = Config.fireStore.collection(path);
    DocumentReference doc = collectionReference.doc(type);
    return doc;
  }

  static Future<List<DocumentSnapshot>> getMyDataByList(
      Map<String, dynamic> lists) async {
    List<DocumentSnapshot> datas = List();
    List<String> keys = lists.keys.toList();
    for (String key in keys) {
      List<String> ids =
          (lists[key] as List)?.map((e) => e as String)?.toList();

      QuerySnapshot snapshot = await Config.fireStore
          .collection(key.substring(0, key.length - 1))
          .where(FieldPath.documentId, whereIn: ids)
          .get();

      datas.addAll(snapshot.docs);
      print('!!! doc lenght :${snapshot.docs.length}');
    }

    return datas;
  }

  /**********************Userinfo****************************/

  /// Userinfo 增- 注册
  static addUserinfo(User user) {
    CollectionReference collectionReference =
        Config.fireStore.collection(STORE_USERINFO);
    print('!!! CollectionReference get');
    var documentReference = collectionReference.doc(user.uid);
    print('!!! DocumentReference get');
    documentReference.set({
      'displayName': user.displayName ?? user.email,
      'photoUrl': user.photoURL
    });
    print('!!! DocumentReference set ok ');
  }

  /// Userinfo 删
  deleteUserinfo(String path) {}

  /// Userinfo 改 - 修改 昵称, 头像
  static updateUserinfo(var value, int type, User user) {
    var document =
        Config.fireStore.collection(STORE_USERINFO).doc(user.uid);

    document.update({keys[type]: value});
  }

  /// Userinfo 改 - 修改 昵称, 头像, 签名, 性别,及其他信息
  static Future<void> updateUserinfoByUser(FireUserInfoEntity user) async{
    var document =
        Config.fireStore.collection(STORE_USERINFO).doc(user.uid);

    return document.update(user.toJson());
  }

  /// Userinfo 查
  static Future<DocumentSnapshot> queryUserinfo(String uid) {
    var collection = Config.fireStore.collection(STORE_USERINFO);
    var doc = collection.doc(uid).get();
    return doc;
  }

  /**********************Square****************************/

  /// Square 增
  static Future<void> addSquare(Square square) async {
    square.date = DateTime.now().millisecondsSinceEpoch;
//    String day = MonthUtil.getCurrentData();
    var collectionReference = Config.fireStore.collection('$STORE_SQUARE');
    var squareReference = await collectionReference.add(square.toJson());
    String listName =
        squareReference.path.replaceAll(squareReference.id, '');
    var userReference = getMySquareList();
    Map<String, dynamic> lists =  (await userReference.get()).data();
    if (lists == null) lists = Map();
    List<String> ids;
    if (lists.containsKey(listName)) {
      ids = (lists[listName] as List)?.map((e) => e as String)?.toList();
    } else
      ids = List();

    ids.add(squareReference.id);
    lists[listName] = ids;
    return userReference.set(lists);
  }

  static DocumentReference getMySquareList() {
    return getUserlistDocumentReferenece(STORE_PUBISH);
  }

  /// Square 删
  deleteSquare(String path) {}

  /// Square 改
  static updateSquare(String path) {}

  /// Square 查
  static Stream<QuerySnapshot> querySquareByType(
      {String type, DocumentSnapshot last, int itemCount}) {
    var collectionReference = Config.fireStore.collection(STORE_SQUARE);
    var query = collectionReference.orderBy('date', descending: true);
    if (type != null) query = query.where('type', isEqualTo: type);
    if (last != null) query = query.startAfterDocument(last);
    if (itemCount != null) query.limit(itemCount);
    return query.snapshots();
  }

  static Future<List<DocumentSnapshot>> querySquareByTypeMore(
      {String type, DocumentSnapshot last, int itemCount}) async {
    var collectionReference = Config.fireStore.collection(STORE_SQUARE);
    var query = collectionReference.orderBy('date', descending: true);
    if (type != null) query = query.where('type', isEqualTo: type);
    if (last != null) query = query.startAfterDocument(last);
    if (itemCount != null) query.limit(itemCount);

    return (await query.get()).docs;
  }

//  static querySquareByUser(String userID, String path) {
//    String day = DateUtil.getDateStrByDateTime(DateTime.now(),
//        format: DateFormat.YEAR_MONTH);
//    var collectionReference =
//        Config.fireStore.collection('$STORE_SQUARE/$path/$day');
//    collectionReference.orderBy('date', descending: true).snapshots();
//  }

//  static Future<QuerySnapshot> getMyPublishList() {
//    String day = DateUtil.getDateStrByDateTime(DateTime.now(),
//        format: DateFormat.YEAR_MONTH);
//    return Config.fireStore
//        .collection('$STORE_SQUARE/default/$day')
//        .where('userID', isEqualTo: Config.user.uid)
//        .getDocuments();
//  }

  /**********************Favorite****************************/

  static Future<void> toggleFavorate(
      DocumentReference squareReference,
      String squareID,
      DocumentReference documentReference,
      Map<String, dynamic> lists,
      bool currentFavoStatae) async {
    String listName = squareReference.path.replaceAll(squareID, '');
    List<String> ids;
    if (lists.containsKey(listName)) {
      ids = (lists[listName] as List)?.map((e) => e as String)?.toList();
    } else
      ids = List();

    if (currentFavoStatae) {
      //ture, make false; remove
      if (ids.contains(squareID)) ids.remove(squareID);
    } else {
      //false make true; add
      ids.add(squareID);
    }
    lists[listName] = ids;
    await documentReference.set(lists);
    return squareReference.update(//ture, make false; remove
        {'favorate': FieldValue.increment(currentFavoStatae ? -1 : 1)});
  }

  static bool isSquareFavorate(Map<String, dynamic> lists, String squareID) {
    if (lists==null || lists.length == 0) return false;
    List<String> keys = lists.keys.toList();
    for (String key in keys) {
      List<String> ids =
          (lists[key] as List)?.map((e) => e as String)?.toList();
      if (ids.contains(squareID)) return true;
    }
    return false;
  }

  //DocumentReference use get can get data, if nodata will return null.
  static DocumentReference getMyFavoratedList() {
    return getUserlistDocumentReferenece(STORE_FAVORATE);
  }

  /**********************Comment****************************/

  static Future<DocumentReference> addComment(String path, String content) {
    String compath = path + STORE_COMMENTS;
    CollectionReference collectionReference =
        Config.fireStore.collection('$compath');
    var com = CommentEntity(
        content: content,
        userID: Config.user.uid,
        time: DateTime.now().millisecondsSinceEpoch);
    return collectionReference.add(com.toJson());
  }

  static Future<QuerySnapshot> getCommentsByPath(
      String path, DocumentSnapshot last,
      {int itemCount}) {
    String compath = path + STORE_COMMENTS;
    print('!!! compath $compath');
    CollectionReference collectionReference =
        Config.fireStore.collection('$compath');
    var query = collectionReference.orderBy('time', descending: true);
    if (last != null) query = query.startAfterDocument(last);
    print('!!! request itemCount is ${itemCount ?? 20}');
    query.limit(itemCount ?? 20);
    return query.get();
  }

  /**********************CHAT****************************/

  static Stream<QuerySnapshot> getConversationList() {
    var query = Config.fireStore
        .collection(STORE_CONVERSATION)
        .where('user', arrayContains: Config.user.uid)
        .orderBy('updateTime', descending: true);
    return query.snapshots();
  }

  /// get conversation by targetID, if none will create one.
  static Future<ConversationEntity> getConversation(String targetID) async {
    var query = Config.fireStore
        .collection(STORE_CONVERSATION)
        .where('user', arrayContains: Config.user.uid)
        .orderBy('updateTime', descending: true);

    var querySnapshot = await query.get();
    var list = querySnapshot.docs;
    for (DocumentSnapshot doc in list) {
      ConversationEntity entity =
          conversationEntityFromJson(ConversationEntity(), doc.data());
      if (entity.user.length == 2 && entity.user.contains(targetID) && entity.user.contains(Config.userInfo.uid)) {
        entity.id = doc.id;
        return entity;
      }
    }
    var entity = ConversationEntity();
    entity.chattype = 0;
    entity.updateTime = DateUtil.getNowDateMs();
    List<String> ids = List();
    ids.add(Config.user.uid);
    ids.add(targetID);
    entity.user = ids;
    var doc = Config.fireStore.collection(STORE_CONVERSATION).doc();
    await doc.set(entity.toJson());
    entity.id = doc.id;
    return entity;
  }

  static Stream<QuerySnapshot> getMessageList(String conversationID) {
    var col = Config.fireStore
        .collection('$STORE_CONVERSATION/$conversationID/contentlist')
        .orderBy('time', descending: true)
        .limit(30);

    return col.snapshots();
  }

  static Future<DocumentReference> addMessageToConversation(
      String conversationID, FireMessageEntity entity) {
    return Config.fireStore
        .collection('$STORE_CONVERSATION/$conversationID/contentlist')
        .add(entity.toJson());
  }

  static updateConversation(
      ConversationEntity conversation, String name, FireMessageEntity msg) {
    var document = Config.fireStore
        .collection(STORE_CONVERSATION)
        .doc(conversation.id);
    if (msg.type == 0) {
      conversation.lastContent = msg.content;
    } else if (msg.type == 1) {
      conversation.lastContent = '图片';
    } else if (msg.type == 2) {
      conversation.lastContent = '表情';
    }
    conversation.lastSenderID = msg.sendID;
    conversation.lastdisplayName =
        msg.sendID == Config.user.uid ? Config.user.displayName : name;
    conversation.updateTime = msg.time;

    document.update(conversation.toJson());
  }

  static deleteConversationEachOther(ConversationEntity conversation) {
    var document = Config.fireStore
        .collection(STORE_CONVERSATION)
        .doc(conversation.id);
    document.delete();
  }

  /**********************RELATIONSHIP****************************/

  static Future<UserInforEntity> getUserInfoRelation(String uid) async {
    String path = '$STORE_USERINFO/${Config.user.uid}/$STORE_RELATIONSHIP';
    var query = Config.fireStore.collection(path).doc(uid);
    var doc = await query.get();
    if (doc.exists) {
      var userinfo = UserInforEntity();
      userInforEntityFromJson(userinfo, doc.data());
      userinfo.uid = doc.id;
      return userinfo;
    } else
      return null;
  }

  static Future<List<UserInforEntity>> getRelationShipList(
      {friend: bool, blacklist: bool}) async {
    var key = '';
    var val = 1;
    if (friend != null) {
      key = 'isFriend';
      val = isFriend;
    }
    if (blacklist != null) {
      key = 'isBlack';
      val = isBlack;
    }

    String path = '$STORE_USERINFO/${Config.user.uid}/$STORE_RELATIONSHIP';
    var query = Config.fireStore
        .collection(path)
        .where(key, isEqualTo: val)
        .orderBy('displayName');
    var data = await query.get();
    var list = data.docs;
    var result = List<UserInforEntity>();
    for (DocumentSnapshot doc in list) {
      var user = UserInforEntity();
      user = userInforEntityFromJson(user, doc.data());
      user.uid = doc.id;
      result.add(user);
    }
    return result;
  }

  static Future<void> operatorRelationShipType(
      UserInforEntity user, String key, dynamic value) async {
    String path = '$STORE_USERINFO/${Config.user.uid}/$STORE_RELATIONSHIP';
    var query = Config.fireStore.collection(path).doc(user.uid);
    var doc = await query.get();
    if (doc.exists) {
      return query.update({key: value});
    } else {
      var map = user.toJson();
      map[key] = value;
      return query.set(map);
    }
  }

  static Future<List<UserInforEntity>> getFriendList() async {
    var list = await getRelationShipList(friend: true);
    //if friend is in blacklist, can't show it.
    for (var i = list.length - 1; i >= 0; i--) {
      //todo should check this vaule if none is ok.
      if (list[i].isBlack == 1) list.remove(i);
    }
    return list;
  }

  static Future<List<UserInforEntity>> getBlackList() {
    return getRelationShipList(blacklist: true);
  }

  static Future<void> operatorFriend(UserInforEntity user, bool firend) async {
    return operatorRelationShipType(user, 'isFriend', firend ? 1 : 0);
  }

  static Future<void> operatorBlackList(UserInforEntity user, bool black) {
    return operatorRelationShipType(user, 'isBlack', black ? 1 : 0);
  }

  static Future<void> editUserRemarkName(
      UserInforEntity user, String remarkName) {
    return operatorRelationShipType(user, 'remarkName', remarkName);
  }
}

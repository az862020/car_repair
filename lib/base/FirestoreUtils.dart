import 'package:car_repair/base/conf.dart';
import 'package:car_repair/entity/Square.dart';
import 'package:car_repair/entity/comment_entity.dart';
import 'package:car_repair/entity/conversation_entity.dart';
import 'package:car_repair/entity/fire_message_entity.dart';
import 'package:car_repair/generated/json/conversation_entity_helper.dart';
import 'package:car_repair/utils/MonthUtil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_repair/entity/FireUserInfo.dart';
import 'package:common_utils/common_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// FireStore 远程数据库.带基础搜索功能.
/// 区分 Userinfo 和 Square.
/// 需要一套 增删改查.
class FireStoreUtils {
  static String STORE_USERINFO = 'userinfo'; //用户信息数据位置
  static String STORE_SQUARE = 'square'; //广场记录的数据位置
  static String STORE_COMMENTS = '/comments'; //广场记录的评论的数据位置
  static String STORE_PUBISH = 'publishList'; //广场记录的评论的数据位置
  static String STORE_FAVORATE = 'favorate'; //广场记录的评论的数据位置
  static String STORE_CONVERSATION = 'conversation'; //会话数据位置

  static final int PHOTOURL = 0; //头像
  static final int DISPLAYName = 1; //昵称
  static final int SIX = 2; //性别
  static final int SIGNATURE = 3; //签名
  static final int BACKGROUND = 4; //头像背景

  static final keys = [
    'photoUrl',
    'displayName',
    'sex',
    'signature',
    'background'
  ];

  static getUserlistDocumentReferenece(String type) {
    String path = '$STORE_USERINFO/${Config.user.uid}/list';
    var collectionReference = Firestore.instance.collection(path);
    DocumentReference doc = collectionReference.document(type);
    return doc;
  }

  static Future<List<DocumentSnapshot>> getMyDataByList(
      Map<String, dynamic> lists) async {
    List<DocumentSnapshot> datas = List();
    List<String> keys = lists.keys.toList();
    for (String key in keys) {
      List<String> ids =
          (lists[key] as List)?.map((e) => e as String)?.toList();

      QuerySnapshot snapshot = await Firestore.instance
          .collection(key.substring(0, key.length - 1))
          .where(FieldPath.documentId, whereIn: ids)
          .getDocuments();

      datas.addAll(snapshot.documents);
      print('!!! doc lenght :${snapshot.documents.length}');
    }

    return datas;
  }

  /**********************Userinfo****************************/

  /// Userinfo 增- 注册
  static addUserinfo(FirebaseUser user) {
    CollectionReference collectionReference =
        Firestore.instance.collection(STORE_USERINFO);
    print('!!! CollectionReference get');
    var documentReference = collectionReference.document(user.uid);
    print('!!! DocumentReference get');
    documentReference.setData({
      'displayName': user.displayName ?? user.email,
      'photoUrl': user.photoUrl
    });
    print('!!! DocumentReference set ok ');
  }

  /// Userinfo 删
  deleteUserinfo(String path) {}

  /// Userinfo 改 - 修改 昵称, 头像, 签名, 性别
  static updateUserinfo(String value, int type, FirebaseUser user) {
    var document =
        Firestore.instance.collection(STORE_USERINFO).document(user.uid);

    document.updateData({keys[type]: value});
  }

  /// Userinfo 查
  static Future<DocumentSnapshot> queryUserinfo(String path) {
    return Firestore.instance
        .collection('$STORE_USERINFO')
        .document(path)
        .get();
  }

  /**********************Square****************************/

  /// Square 增
  static Future<void> addSquare(Square square) async {
    square.date = DateTime.now().millisecondsSinceEpoch;
//    String day = MonthUtil.getCurrentData();
    var collectionReference = Firestore.instance.collection('$STORE_SQUARE');
    var squareReference = await collectionReference.add(square.toJson());
    String listName =
        squareReference.path.replaceAll(squareReference.documentID, '');
    var userReference = getMySquareList();
    Map<String, dynamic> lists = (await userReference.get()).data;
    if (lists == null) lists = Map();
    List<String> ids;
    if (lists.containsKey(listName)) {
      ids = (lists[listName] as List)?.map((e) => e as String)?.toList();
    } else
      ids = List();

    ids.add(squareReference.documentID);
    lists[listName] = ids;
    return userReference.setData(lists);
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
    var collectionReference = Firestore.instance.collection(STORE_SQUARE);
    var query = collectionReference.orderBy('date', descending: true);
    if (type != null) query = query.where('type', isEqualTo: type);
    if (last != null) query = query.startAfterDocument(last);
    if (itemCount != null) query.limit(itemCount);
    return query.snapshots();
  }

  static Future<List<DocumentSnapshot>> querySquareByTypeMore(
      {String type, DocumentSnapshot last, int itemCount}) async {
    var collectionReference = Firestore.instance.collection(STORE_SQUARE);
    var query = collectionReference.orderBy('date', descending: true);
    if (type != null) query = query.where('type', isEqualTo: type);
    if (last != null) query = query.startAfterDocument(last);
    if (itemCount != null) query.limit(itemCount);

    return (await query.getDocuments()).documents;
  }

//  static querySquareByUser(String userID, String path) {
//    String day = DateUtil.getDateStrByDateTime(DateTime.now(),
//        format: DateFormat.YEAR_MONTH);
//    var collectionReference =
//        Firestore.instance.collection('$STORE_SQUARE/$path/$day');
//    collectionReference.orderBy('date', descending: true).snapshots();
//  }

//  static Future<QuerySnapshot> getMyPublishList() {
//    String day = DateUtil.getDateStrByDateTime(DateTime.now(),
//        format: DateFormat.YEAR_MONTH);
//    return Firestore.instance
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
    await documentReference.setData(lists);
    return squareReference.updateData(//ture, make false; remove
        {'favorate': FieldValue.increment(currentFavoStatae ? -1 : 1)});
  }

  static bool isSquareFavorate(Map<String, dynamic> lists, String squareID) {
    if (lists.length == 0) return false;
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
        Firestore.instance.collection('$compath');
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
        Firestore.instance.collection('$compath');
    var query = collectionReference.orderBy('time', descending: true);
    if (last != null) query = query.startAfterDocument(last);
    print('!!! request itemCount is ${itemCount ?? 20}');
    query.limit(itemCount ?? 20);
    return query.getDocuments();
  }

  /**********************CHAT****************************/

  static Future<QuerySnapshot> getConversationList() {
    var query = Firestore.instance
        .collection(STORE_CONVERSATION)
        .where('user', arrayContains: Config.user.uid)
        .orderBy('updateTime', descending: true);
    return query.getDocuments();
  }

  static Future<ConversationEntity> getConversation(String targetID) async {
    var query = Firestore.instance
        .collection(STORE_CONVERSATION)
        .where('user', arrayContains: Config.user.uid)
        .orderBy('updateTime', descending: true);

    var querySnapshot = await query.getDocuments();
    var list = querySnapshot.documents;
    for (DocumentSnapshot doc in list) {
      var entity = conversationEntityFromJson(ConversationEntity(), doc.data);
      if (entity.user.length == 2 && entity.user.contains(targetID)) {
        return entity;
      }
    }
    var entity = ConversationEntity();
    entity.chattype = 0;
    entity.updateTime = DateUtil.getNowDateMs();
    List<String> ids = List();
    ids.add(userID);
    ids.add(targetID);
    entity.user = ids;
    var doc = Firestore.instance.collection(STORE_CONVERSATION).document();
    await doc.setData(entity.toJson());
    entity.id = doc.documentID;
    return entity;
  }

  static Stream<QuerySnapshot> getMessageList(String conversationID)  {
    var col = Firestore.instance
        .collection('$STORE_CONVERSATION/$conversationID/contentlist');

    return  col.snapshots();
  }

  static addMessageToConversation(String conversationID, FireMessageEntity entity) {
    Firestore.instance
        .collection('$STORE_CONVERSATION/$conversationID/contentlist')
        .add(entity.toJson());
  }
}

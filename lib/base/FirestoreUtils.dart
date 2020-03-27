import 'package:car_repair/base/conf.dart';
import 'package:car_repair/entity/Square.dart';
import 'package:car_repair/entity/comment_entity.dart';
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


  static final int PHOTOURL = 0; //头像
  static final int DISPLAYName = 1; //昵称
  static final int SIX = 2; //性别
  static final int SIGNATURE = 3; //签名
  static final int BACKGROUND = 4; //头像背景

  static final keys = ['photoUrl', 'displayName', 'sex', 'signature','background'];

  /**********************Userinfo****************************/
  /// Userinfo 增- 注册
  static addUserinfo(FirebaseUser user) {

    CollectionReference collectionReference = Firestore.instance.collection(STORE_USERINFO);
    print('!!! CollectionReference get');
    DocumentReference documentReference = collectionReference.document(user.uid);
    print('!!! DocumentReference get');
    documentReference.setData({'displayName':user.displayName, 'photoUrl':user.photoUrl});
    print('!!! DocumentReference set ok ');
  }

  /// Userinfo 删
  deleteUserinfo(String path) {}

  /// Userinfo 改 - 修改 昵称, 头像, 签名, 性别
  static updateUserinfo(String value, int type,  FirebaseUser user) {

    var document = Firestore.instance.collection(STORE_USERINFO).document(user.uid);

    document.updateData({keys[type]:value});
  }

  /// Userinfo 查
  static Future<DocumentSnapshot> queryUserinfo(String path){
//    QuerySnapshot snapshot = await Firestore.instance.collection(path).getDocuments();
//    DocumentSnapshot sd = snapshot.documents.first;
//    FireUserInfo userInfo = FireUserInfo.fromJson(sd.data);
//    userInfo.uid = sd.documentID;
//    return userInfo;
    return Firestore.instance.collection('$STORE_USERINFO').document(path).get();
  }

  /**********************Square****************************/

  /// Square 增
  static Future<DocumentReference> addSquare(Square square, String squarePath) {
    square.date = DateTime.now().millisecondsSinceEpoch;
    String day =DateUtil.getDateStrByDateTime(DateTime.now(), format: DateFormat.YEAR_MONTH);
    CollectionReference collectionReference = Firestore.instance.collection('$STORE_SQUARE/$squarePath/$day');
    print('!!! CollectionReference get');
    return collectionReference.add(square.toJson());
//    DocumentReference documentReference = collectionReference.document(user.uid);
//    print('!!! DocumentReference get');
//    documentReference.setData({'displayName':user.displayName, 'photoUrl':user.photoUrl});

  }

  /// Square 删
  deleteSquare(String path) {}

  /// Square 改
  static updateSquare(String path) {}

  /// Square 查
  static Stream<QuerySnapshot> querySquareByType(String path) {
    String day =DateUtil.getDateStrByDateTime(DateTime.now(), format: DateFormat.YEAR_MONTH);
    CollectionReference collectionReference = Firestore.instance.collection('$STORE_SQUARE/$path/$day');
    return collectionReference.orderBy('date', descending: true).snapshots();
  }

  static querySquareByUser(String userID, String path){
    String day =DateUtil.getDateStrByDateTime(DateTime.now(), format: DateFormat.YEAR_MONTH);
    CollectionReference collectionReference = Firestore.instance.collection('$STORE_SQUARE/$path/$day');
    collectionReference.orderBy('date', descending: true).snapshots();
  }


  /**********************Comment****************************/

  static Future<DocumentReference> addComment(String path, String content){
    String compath = path + STORE_COMMENTS;
    CollectionReference collectionReference = Firestore.instance.collection('$compath');
    var com = CommentEntity(content: content, userID: Config.user.uid, time: DateTime.now().millisecondsSinceEpoch);
    return collectionReference.add(com.toJson());
  }

  static Future<QuerySnapshot> getCommentsByPath(String path, DocumentSnapshot last, {int itemCount}){
    String compath = path + STORE_COMMENTS;
    print('!!! compath $compath');
    CollectionReference collectionReference = Firestore.instance.collection('$compath');
    var query = collectionReference.orderBy('time', descending: true);
    if(last != null)
      query = query.startAfterDocument(last);
    print('!!! request itemCount is ${itemCount??20}');
    query.limit(itemCount??20);
    return query.getDocuments();
  }
}

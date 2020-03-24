import 'package:car_repair/entity/Square.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_repair/entity/UserInfo.dart';
import 'package:common_utils/common_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



/// FireStore 远程数据库.带基础搜索功能.
/// 区分 Userinfo 和 Square.
/// 需要一套 增删改查.
class FireStoreUtils {
  static String STORE_USERINFO = 'userinfo'; //云端头像文件存放路径
  static String STORAGE_SQUARE = 'square'; //广场记录的存储路径


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
  static queryUserinfo(String path) {}

  /**********************Square****************************/

  /// Square 增
  static Future<DocumentReference> addSquare(Square square, String squarePath) {
    square.date = DateTime.now().millisecondsSinceEpoch;
    String day =DateUtil.getDateStrByDateTime(DateTime.now(), format: DateFormat.YEAR_MONTH);
    CollectionReference collectionReference = Firestore.instance.collection('$STORAGE_SQUARE/$squarePath/$day');
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
    CollectionReference collectionReference = Firestore.instance.collection('$STORAGE_SQUARE/$path/$day');
    return collectionReference.orderBy('date', descending: true).snapshots();
  }
}

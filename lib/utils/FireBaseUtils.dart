import 'dart:io';

import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/base/Config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import 'DBEntity/UploadTask.dart';
import 'DBEntity/UploadTemp.dart';
import 'DBHelp.dart';
import 'package:car_repair/entity/Square.dart';

import 'FileUploadRecord.dart';
import 'package:car_repair/base/Config.dart';

import 'package:uuid/uuid.dart';

class FireBaseUtils {
  static final int PHOTOURL = 0; //头像
  static final int DISPLAYName = 1; //昵称

  static String STORAGE_PHOTOURL_PATH = 'userinfo/photoUrl/'; //云端头像文件存放路径
//  static String STORAGE_SQUARE_PATH = 'square/'; //云端广场文件存放路径

  /// 上传图片
  /// context 用于 开启/关闭 Dialog, pop 当前界面.
  /// _image 上传的文件肯定要传.
  /// CouldPath 云端的文件路径, 上传到哪儿. 也用于确定后续逻辑.
  static uploadPhotoUrl(BuildContext context, File _image, String CouldPath) {
    String path = _image.absolute.path;
    String name = basename(path);
    path = path.substring(path.lastIndexOf('/'));

    String url = CouldPath + Config.user.uid;
    print('!!! url $url');
    print('!!! img $_image');

    var reference = FirebaseStorage.instance.ref().child(url).child(name);
    reference.putFile(_image).events.listen((event) {
      print('!!! event ${event.type}');
      if (event.type == StorageTaskEventType.success ||
          event.type == StorageTaskEventType.failure ||
          event.type == StorageTaskEventType.pause) {
        // stop upload.
//        isLoad = false;
        if (event.type == StorageTaskEventType.success) {
          if (CouldPath == STORAGE_PHOTOURL_PATH) {
            //photoUrl
            updateUserInfo(Config.storage.storageBucket + reference.path, PHOTOURL)
                .then((user) {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pop(context);
            });
          }
        } else if (event.type == StorageTaskEventType.failure) {
          Navigator.pop(context, 'dialog');
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Upload failure.')));
        }
      } else if (event.type == StorageTaskEventType.progress) {
        var snapshot = event.snapshot;
        print('!!! ${snapshot.bytesTransferred} / ${snapshot.totalByteCount}');
        var procent = snapshot.bytesTransferred / snapshot.totalByteCount * 100;
        print('!!! $procent%');
//        isLoad = true;
      }
    });
    Config.showLoadingDialog(context);
  }

  /// 更新用户信息. Auth 上的.
  static Future<FirebaseUser> updateUserInfo(String updateInfo, int type,
      {BuildContext dialogContext}) async {
    print('!!! update type $type to user $updateInfo');
    if (dialogContext != null) Config.showLoadingDialog(dialogContext);
    UserUpdateInfo info = UserUpdateInfo();
    if (type == PHOTOURL) {
      info.photoUrl = updateInfo;
      info.displayName = Config.user.displayName ?? Config.user.email;
    } else if (type == DISPLAYName) {
      info.photoUrl = Config.user.photoUrl;
      info.displayName = updateInfo;
    }
    if (dialogContext == null)
      return await _updateUserInfo(info, type);
    else
      await _updateUserInfo(info, type);
    Navigator.of(dialogContext, rootNavigator: true).pop();
    Navigator.of(dialogContext).pop();
  }

  /// 更新用户信息. FireStore上的. 如果是头像, 删除老头像, 重新加载用户信息, 赋值到公共变量.
  static Future<FirebaseUser> _updateUserInfo(
      UserUpdateInfo info, int type) async {
    if (Config.user == null) return null;
    await Config.user.updateProfile(info);
    if (type == PHOTOURL && Config.user.photoUrl != null)
      FirebaseStorage.instance
          .ref()
          .child(Config.user.photoUrl.replaceAll(RegExp(Config.AppBucket), ''))
          .delete();
    await Config.user.reload();
    Config.user = await FirebaseAuth.instance.currentUser();
    //update firestore data.
    FireStoreUtils.updateUserinfo(type == PHOTOURL? info.photoUrl : info.displayName , type,  Config.user);
    return Config.user;
  }

  ///文件已上传, 开始更新广场信息.
  static Future<Null> updateFireStore(int taskID, String squarePath, {Function(bool) done}) async {
    //all file had uploaded, update the data.
    List<UploadTemp> temps = await getUploadTemps(taskID);
    print('!!! ${temps.first.toMap().toString()}');
    UploadTask uploadtask = await getTask(taskID);
    print('!!! ${uploadtask.toMap().toString()}');
    List<String> res = List();
    for (int i = 0; i < temps.length; i++) {
      res.add(temps[i].cloudPath);
    }
    Square square =
        Square(uploadtask.title, uploadtask.describe, Config.user.uid, type: squarePath);
    if (res.length > 0) {
      if (uploadtask.type == FileUploadRecord.mediaType_video) {
        square.video = res.first;
      } else if (uploadtask.type == FileUploadRecord.mediaType_picture) {
        square.pics = res;
      }
    }
    print('!!! ${square.toString()}');
//    square.id = Uuid().v1();
    print('!!! ${square.toJson().toString()}');

    FireStoreUtils.addSquare(square).then((data) {
      if (done != null) done(true);
    }).catchError((err) {
      if (done != null) done(false);
    });

//    Config.store
//        .collection(FileUploadRecord.STOR_SQUARE_PATH)
//        .document()
//        .setData(square.toJson())
////        .add(square.toJson())
//        .whenComplete(() {
//      if (done != null) done(true);
//    }).catchError(() {
//      if (done != null) done(false);
//    });
  }
}

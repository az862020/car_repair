import 'dart:io';

import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/base/Config.dart';
import 'package:car_repair/entity/fire_user_info_entity.dart';
import 'package:car_repair/entity/user_infor_entity.dart';
import 'package:car_repair/generated/json/user_infor_entity_helper.dart';
import 'package:car_repair/utils/UserInfoManager.dart';
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
  static String STORAGE_BACKGROUND_PATH =
      'userinfo/backgroundPhoto/'; //云端头像文件存放路径
//  static String STORAGE_SQUARE_PATH = 'square/'; //云端广场文件存放路径

  /// 上传图片
  /// context 用于 开启/关闭 Dialog, pop 当前界面.
  /// _image 上传的文件肯定要传.
  /// CouldPath 云端的文件路径, 上传到哪儿. 也用于确定后续逻辑.
  static uploadPhotoUrl(BuildContext context, File _image, String CouldPath,
      {Function(bool, {String url}) done}) {
    Config.showLoadingDialog(context);
    String path = _image.absolute.path;
    String name = basename(path);
    path = path.substring(path.lastIndexOf('/'));

    String url = CouldPath + Config.user.uid;
    print('!!! url $url');
    print('!!! img $_image');
    var reference = FirebaseStorage.instance.ref().child('$url/$name');
    reference.putFile(_image).events.listen((event) {
      print('!!! event ${event.type}');
      if (event.type == StorageTaskEventType.success) {
        var path = event.snapshot.ref.path;
        print('!!! upload finish path $path');
        String photoURL = '${Config.AppBucket}$url/$name';
        print('!!! upload finish photoURL $photoURL');
        Navigator.of(context, rootNavigator: true).pop();
        if (CouldPath == STORAGE_PHOTOURL_PATH) {
          //photoUrl
          updateUserInfo(photoURL: photoURL).then((user) {
            Navigator.pop(context);
          });
        } else if (CouldPath == STORAGE_BACKGROUND_PATH) {
          //backgroundPhoto
          if (done != null) done(true, url: photoURL);
        }
      } else if (event.type == StorageTaskEventType.failure) {
        Navigator.of(context, rootNavigator: true).pop();
        if (CouldPath == FireStoreUtils.BACKGROUND) {
          if (done != null) done(false);
        } else if (CouldPath == STORAGE_PHOTOURL_PATH) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Upload failure.')));
        }
      } else if (event.type == StorageTaskEventType.progress) {
        var snapshot = event.snapshot;
        print('!!! ${snapshot.bytesTransferred} / ${snapshot.totalByteCount}');
        var procent = snapshot.bytesTransferred / snapshot.totalByteCount * 100;
        print('!!! $procent%');
      }
    });

  }

  /// 更新用户信息. Auth 上的.
  static Future<User> updateUserInfo(
      {BuildContext dialogContext, String displayName, String photoURL}) async {
    if (dialogContext != null) Config.showLoadingDialog(dialogContext);

    if (dialogContext == null)
      return await _updateUserInfo(
          displayName: displayName, photoURL: photoURL);
    else
      await _updateUserInfo(displayName: displayName, photoURL: photoURL);
    Navigator.of(dialogContext, rootNavigator: true).pop();
    Navigator.of(dialogContext).pop();
  }

  /// 更新用户信息. FireStore上的. 如果是头像, 删除老头像, 重新加载用户信息, 赋值到公共变量.
  static Future<User> _updateUserInfo(
      {String displayName, String photoURL}) async {
    if (Config.user == null) return null;

    //1.upload file
    await Config.user.updateProfile(
        displayName: displayName ?? Config.user.displayName,
        photoURL: photoURL ?? Config.user.photoURL);

    //2.update firestore data.
    int type = photoURL != null ? PHOTOURL : DISPLAYName;
    FireStoreUtils.updateUserinfo(displayName ?? photoURL, type, Config.user);

    //3.delete old file
    if (Config.user.photoURL != null && photoURL != null) {
      var lastphoto =
          Config.user.photoURL.replaceAll(RegExp(Config.AppBucket), '');
      print('!!! lastphoto : $lastphoto');
      var old = Config.storage.ref().child(lastphoto);
      old.delete().catchError((e) => print('!!! $e'));
    }

    //4.refresh user info
    await Config.user.reload();
    Config.user = Config.auth.currentUser;
    print('!!! User --- ${Config.user}');

    //5.cache new user data
    if (displayName != null)
      Config.userInfo.displayName = displayName;
    else
      Config.userInfo.photoUrl = photoURL;
    UserInfoManager.refreshSelf();

    return Config.user;
  }

  static Future<FireUserInfoEntity> updateUserInfoDetails(FireUserInfoEntity userinfo) async {
    if (Config.userInfo == null) return null;

    //1.delete old file
    if (userinfo.backgroundPhoto != null &&
        Config.userInfo.backgroundPhoto != null &&
        Config.userInfo.backgroundPhoto != userinfo.backgroundPhoto) {
      var lastphoto =
      Config.userInfo.backgroundPhoto.replaceAll(RegExp(Config.AppBucket), '');
      var old = Config.storage.ref().child(lastphoto);
      old.delete().catchError((e) => print('!!! $e'));

    }

    //2.refresh user info by display
    Config.userInfo = userinfo;
    if (userinfo.displayName != Config.userInfo.displayName) {
      await Config.user.reload();
      Config.user = Config.auth.currentUser;

      //5.cache new user data
      UserInfoManager.refreshSelf();
    }


    return Config.userInfo;
  }

  ///文件已上传, 开始更新广场信息.
  static Future<Null> updateFireStore(int taskID, String squarePath,
      {Function(bool) done}) async {
    //all file had uploaded, update the data.
    List<UploadTemp> temps = await getUploadTemps(taskID);
    print('!!! ${temps.first.toMap().toString()}');
    UploadTask uploadtask = await getTask(taskID);
    print('!!! ${uploadtask.toMap().toString()}');
    List<String> res = List();
    for (int i = 0; i < temps.length; i++) {
      res.add(temps[i].cloudPath);
    }
    Square square = Square(
        uploadtask.title, uploadtask.describe, Config.user.uid,
        type: squarePath);
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
  }
}

import 'dart:io';

import 'package:car_repair/base/conf.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

import 'DBEntity/UploadTask.dart';
import 'DBEntity/UploadTemp.dart';
import 'DBHelp.dart';
import 'package:car_repair/entity/Square.dart';

import 'FileUploadRecord.dart';
import 'package:car_repair/base/conf.dart';

class FireBaseUtils {
  static final int PHOTOURL = 1; //头像
  static final int DISPLAYName = 2; //昵称

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
            updateUserInfo(
                    Config.storage.storageBucket + reference.path, PHOTOURL)
                .then((user) {
              Navigator.of(context, rootNavigator: true).pop(user);
              Navigator.of(context).pop(user);
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

  /// 更新用户信息.
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

  /// 更新用户信息. 如果是头像, 删除老头像, 重新加载用户信息, 赋值到公共变量.
  static Future<FirebaseUser> _updateUserInfo(
      UserUpdateInfo info, int type) async {
    if (Config.user == null) return null;
    await Config.user.updateProfile(info);
    if (type == PHOTOURL)
      FirebaseStorage.instance
          .ref()
          .child(Config.user.photoUrl.replaceAll(Config.AppBucket, ''))
          .delete();
    await Config.user.reload();
    Config.user = await FirebaseAuth.instance.currentUser();
    return Config.user;
  }

  ///文件已上传, 开始更新广场信息.
  static Future<Null> update(int taskID, {Function(bool) done}) async {
    //all file had uploaded, update the data.
    List<UploadTemp> temps = await getUploadTemps(taskID);
    UploadTask uploadtask = await getTask(taskID);
    List<String> res = List();
//    if (uploadtask.type == FileUploadRecord.mediaType_video) {
//      res.add(temps.first.cloudPath);
//    } else {}
    for (int i = 0; i < temps.length; i++) {
      res.add(temps[i].cloudPath);
    }
    Square square = Square(
        BigInt.from(0),
        uploadtask.title,
        uploadtask.describe,
        uploadtask.type == FileUploadRecord.mediaType_video ? res.first : null,
        uploadtask.type == FileUploadRecord.mediaType_picture ? res : null);

    Config.store
        .collection(FileUploadRecord.STOR_SQUARE_PATH)
        .document()
        .setData(square.toJson())
        .whenComplete(() {
      if (done != null) done(true);
    }).catchError(() {
      if (done != null) done(false);
    });
  }
}

import 'dart:io';

import 'package:car_repair/base/conf.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

class FireBaseUtils {
  static final int PHOTOURL = 1; //头像
  static final int DISPLAY = 2; //昵称

  static String STORAGE_PHOTOURL_PATH = 'userinfo/photoUrl/'; //云端头像文件存放路径

  /// 上传图片
  /// context 用于 开启/关闭 Dialog, pop 当前界面.
  /// _image 上传的文件肯定要传.
  /// CouldPath 云端的文件路径, 上传到哪儿. 也用于确定后续逻辑.
  static uploadPhotoUrl(BuildContext context, File _image, String CouldPath) {
    String path = _image.absolute.path;
    String name = path.substring(path.lastIndexOf('/') + 1);
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
            updatePhotoUrl(
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
  static Future<FirebaseUser> updatePhotoUrl(
      String updateInfo, int type) async {
    print('!!! update type $type to user $updateInfo');
    UserUpdateInfo info = UserUpdateInfo();
    if (type == PHOTOURL) {
      info.photoUrl = updateInfo;
      info.displayName = Config.user.displayName == null
          ? Config.user.email
          : Config.user.displayName;
    } else if (type == DISPLAY) {
      info.photoUrl = Config.user.photoUrl;
      info.displayName = updateInfo;
    }

    return await updateUserInfo(info);
  }

  /// 更新用户信息.
  static Future<FirebaseUser> updateUserInfo(UserUpdateInfo info) async {
    if (Config.user == null) return null;

    await Config.user.updateProfile(info);
    await Config.user.reload();
    Config.user = await FirebaseAuth.instance.currentUser();
    return Config.user;
  }
}

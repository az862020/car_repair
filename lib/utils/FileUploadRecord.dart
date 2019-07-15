import 'package:car_repair/base/conf.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_jpeg/image_jpeg.dart';
import 'dart:io';
import 'package:car_repair/utils/DBHelp.dart';
import 'package:uuid/uuid.dart';
import 'DBEntity/DownloadFile.dart';
import 'DBEntity/UploadEntity.dart';
import 'DBEntity/UploadTemp.dart';
import 'DBUtil.dart';

import 'FireBaseUtils.dart';

class FileUploadRecord {
  static String STORAGE_SQUARE_PATH = 'square/'; //云端广场文件存放路径

  static upload(String filePath) {}

  static uploadFile(
      BuildContext context, UploadTemp temp, Function(bool) callback) async {
    //TODO single upload task
    UploadEntity entity = await getUploadEntity(temp.filePath);
    if (entity == null) {
      entity = UploadEntity(temp.filePath, '', '', '');
      await insertUploadEntity(entity);
    }
    //1. encodejpeg
    if (entity.proxyPath.isEmpty) {
      var name = '${Uuid().v1()}.jpg';
      String jpegPath = '${Config.AppDirCache}$name';
      String path = await ImageJpeg.encodeJpeg(
          entity.localPath, jpegPath, 80, 1920, 1080);
      print('!!! encodeJpge result: $path');
      entity.proxyPath = path;
      //2 save to db
      await updateUploadEntity(entity);
    }

    //3. upload
    if (entity.cloudPath.isEmpty) {
      var reference = FirebaseStorage.instance.ref().child(STORAGE_SQUARE_PATH);
      File file = File(entity.proxyPath);
      int length = await file.length();
      var url = STORAGE_SQUARE_PATH + 'fileName';
      reference.putFile(file).events.listen((event) {
        if (event.type == StorageTaskEventType.success) {
          //4. update to db
          insertFile(DownloadFile(url, entity.proxyPath, length));
        } else if (event.type == StorageTaskEventType.failure) {
          callback(false);
        }
      });
    } else {
      callback(true);
    }
  }

  static uploadFiles(BuildContext context, List<String> paths, int type,
      String title, String describe, Function done) {
    //TODO multi file upload task.
    if (paths == null || paths.length == 0)
      throw Exception('Can not find files to upload.');

    DBUtil.addTask(paths, type, title, describe, (temps) {
      for (var i = 0; i < temps.length; i++) {
        uploadFile(context, temps[i], (isOk) {
          //TODO check is all upload finish.
        });
      }
    });
  }
}

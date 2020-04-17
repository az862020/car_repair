import 'package:car_repair/base/Config.dart';
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
import 'package:car_repair/utils/FireBaseUtils.dart';

import 'package:path/path.dart';

import 'FireBaseUtils.dart';

class FileUploadRecord {
  static String STORAGE_SQUARE_PATH = 'square/'; //云端广场文件存放路径
  static String STORAGE_CHAT_PATH = 'chat/'; //云端聊天文件存放路径
  static String STOR_SQUARE_PATH = 'Square'; //云端广场文档记录路径
  static int type_square = 0;
  static int type_chat = 1;

  static int mediaType_picture = 0;
  static int mediaType_video = 1;

  static upload(String filePath) {}

  static uploadFiles(BuildContext context, List<String> paths, int type,
      int mediaType, String title, String describe, String square,
      {Function(bool) done, Function(String) done2}) {
    // multi file upload task.
    if (paths == null || paths.length == 0)
      throw Exception('Can not find files to upload.');
    bool hasCallBack = false;
    DBUtil.addTask(paths, type, mediaType, title, describe, (temps) {
      print('!!! $temps');
      for (var i = 0; i < temps.length; i++) {
        print('!!! ${temps[i]}');
        uploadFile(context, temps[i], square, type, (temp) {
          // check is all upload finish.
          print('!!! has callback: $hasCallBack');
          if (hasCallBack) return;
          print('!!! has done: ${temp.isDone}');
          if (temp.isDone == 0) {
            hasCallBack = true;
            done(false);
          }
          DBUtil.isTaskAllDone(temp.tasktID).then((isOK) {
            if (isOK) {
              hasCallBack = true;
              if (type == 0) {
                FireBaseUtils.updateFireStore(temp.tasktID, square, done: done);
              } else {
                if (done2 != null) {
                  done2(temp.cloudPath);
                }
              }
            }
          });
        });
      }
    });
  }

  static uploadFile(BuildContext context, UploadTemp temp, String square, int type,
      Function(UploadTemp) callback) async {
    // single upload task
    print('!!! ready to upload file ${temp.filePath}');
    UploadEntity entity = await getUploadEntity(temp.filePath);
    if (entity == null) {
      print('!!! 需要新建上传文件记录!');
      entity = UploadEntity(temp.filePath);
      await insertUploadEntity(entity);
    }
    //1. encodejpeg
    if (entity.proxyPath == null) {
      print('!!! 需要压缩, 新建压缩文件!');
      var name =
          Uuid().v1() + (temp.filePath.endsWith('.gif') ? '.gif' : '.jpg');
      String target = '${Config.AppDirCache}$name';
      String path = target;
      if (temp.filePath.endsWith('.gif')) {
        //gif
        File targetFile = File(target);
        bool exist = await targetFile.exists();
        if (!exist) targetFile.create(recursive: true);
        await File(temp.filePath).copy(target).then((file) {
          path = file.path;
        }).catchError((e) {
          path = temp.filePath;
        });
      } else {
        //jpg png
        path = await ImageJpeg.encodeJpeg(
            entity.localPath, target, 80, 1920, 1080);
      }
      print('!!! encodeJpge result: $path');
      entity.proxyPath = path;
      //2 save to db
      await updateUploadEntity(entity);
    }

    //3. upload
    if (entity.cloudPath == null) {
      print('!!! 需要上传, 新建云端文件!');
      File file = File(entity.proxyPath);
      var filename = entity.proxyPath.split('/').last;

      var reference = FirebaseStorage.instance
          .ref();
      if(type == type_square){
          reference.child(STORAGE_SQUARE_PATH + '$square/' + filename);
      }else if (type == type_chat){
          reference.child(STORAGE_CHAT_PATH + '$square/' + filename);
      }

      reference.putFile(file).events.listen((event) {
        if (event.type == StorageTaskEventType.success) {
          //4. update to db
          print('!!! 上传文件成功');
          entityFinish(temp, entity, square, file).then((temp) {
            print('!!! 上传文件成功, 数据库记录状态更新成功.');
            callback(temp);
          }).catchError((e) => callback(temp));
        } else if (event.type == StorageTaskEventType.failure) {
          callback(temp);
        }
      });
    } else {
      print('!!! 已上传, 复制并保存云端链接');
      print('!!! ${temp.toString()}');
      print('!!! ${entity.toString()}');
      if (temp.isDone == 1 && temp.cloudPath != null) {
        callback(temp);
      } else {
        tempFinish(temp, entity.cloudPath).then((temp) {
          callback(temp);
        }).catchError((e) {
          print('!!! $e');
          callback(temp);
        });
      }
    }
  }

  static Future<UploadTemp> entityFinish(
      UploadTemp temp, UploadEntity entity, String square, File file) async {
    int length = await file.length();
    var url = '$STORAGE_SQUARE_PATH$square/${basename(entity.proxyPath)}';
    entity.cloudPath = url;
    await updateUploadEntity(entity);
    await insertFile(DownloadFile(url, entity.proxyPath, length));
    print('!!! 保存上传记录成功.');
    tempFinish(temp, url);
    return temp;
  }

  static Future<UploadTemp> tempFinish(UploadTemp temp, String url) async {
    temp.cloudPath = url;
    temp.isDone = 1;
    await updateUploadTemp(temp);
    print('!!! 保存任务记录成功.');
    return temp;
  }
}

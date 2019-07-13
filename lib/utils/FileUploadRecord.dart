import 'package:car_repair/base/conf.dart';
import 'package:flutter/widgets.dart';
import 'package:image_jpeg/image_jpeg.dart';
import 'dart:io';
import 'package:car_repair/utils/DBHelp.dart';

import 'FireBaseUtils.dart';

class FileUploadRecord {
  static upload(String filePath) {}

  static uploadFile(BuildContext context, String paths) async {
    //TODO single upload task
    //1. encodejpeg
    //2 save to db
    //3. upload
    //4. update to db

    String jpegPath =
        '${Config.AppDirCache}${DateTime.now().millisecondsSinceEpoch}.jpg';

    String path = await ImageJpeg.encodeJpeg(paths, jpegPath, 80, 1920, 1080);
    print('!!! encodeJpge result: $path');
    FireBaseUtils.uploadPhotoUrl(
        context, File(path), FireBaseUtils.STORAGE_SQUARE_PATH);
  }

  static uploadFiles(BuildContext context, List<String> paths, Function done) {
    //TODO multi file upload task.
    if (paths == null || paths.length == 0)
      throw Exception('Can not find files to upload.');

    for (var i = 0; i < paths.length; i++) {
      uploadFile(context, paths[i]);
    }
  }
}

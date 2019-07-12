import 'package:car_repair/base/conf.dart';
import 'package:flutter/widgets.dart';
import 'package:image_jpeg/image_jpeg.dart';
import 'dart:io';

import 'FireBaseUtils.dart';

class FileUploadRecord {
  static uploadFile(BuildContext context, String paths) async {
    //TODO single upload task
    String jpegPath =
        '${Config.AppDirCache}${DateTime.now().millisecondsSinceEpoch}.jpg';
    ImageJpeg.encodeJpeg(paths, jpegPath, 80, 1920, 1080).then((string) {
      print('!!! encodeJpge result: $string');
      FireBaseUtils.uploadPhotoUrl(
          context, File(string), FireBaseUtils.STORAGE_SQUARE_PATH);
    });
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

import 'package:car_repair/base/conf.dart';
import 'package:image_jpeg/image_jpeg.dart';

class FileUploadRecord {
  static uploadFile(String paths) async {
    //TODO single upload task
    String jpegPath =
        '${Config.AppDirCache}${DateTime.now().millisecondsSinceEpoch}.jpg';
    ImageJpeg.encodeJpeg(paths, jpegPath, 80, 1920, 1080).then((string) {
      print('!!! encodeJpge result: $string');
    });
  }

  static uploadFiles(String key, List<String> paths, Function done) {
    //TODO multi file upload task.
    if (paths == null || paths.length == 0)
      throw Exception('Can not find files to upload.');

    for (var i = 0; i < paths.length; i++) {
      uploadFile(paths[i]);
    }
  }
}

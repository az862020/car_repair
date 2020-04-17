
import 'package:car_repair/utils/FileDownloadRecord.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'Config.dart';

class CloudCacheManager extends BaseCacheManager {
  static const key = "customCache";

  static CloudCacheManager _instance;

  static bool isFileProxy = true;

  factory CloudCacheManager() {
    if (_instance == null) {
      _instance = new CloudCacheManager._();
    }
    return _instance;
  }

  CloudCacheManager._() : super(key, fileFetcher: _customHttpGetter);

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }

  static Future<FileFetcherResponse> _customHttpGetter(String url,
      {Map<String, String> headers}) async {
    url = url.replaceAll(RegExp(Config.AppBucket), '');
    StorageReference reference = FirebaseStorage.instance.ref().child(url);
    // Do things with headers, the url or whatever.
    if (isFileProxy) {
      //download the file first, and then link the file to the response, just want be fast.
      print('!!! download file use CloudCacheManager');
      http.Response _response = await FileDownloadRecord.getFileResponse(url);

      return HttpFileFetcherResponse(_response);
    } else {
      //get getDownloadURL from http. and then download from http. too slow.
      url = await reference.getDownloadURL();
      return HttpFileFetcherResponse(await http.get(url, headers: headers));
    }
  }

}

import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'conf.dart';

class CloudCacheManager extends BaseCacheManager {
  static const key = "customCache";

  static CloudCacheManager _instance;

  factory CloudCacheManager() {
    if (_instance == null) {
      _instance = new CloudCacheManager._();
    }
    print('!!! CloudCacheManager factory');
    return _instance;
  }

  CloudCacheManager._()
      : super(key,
            maxAgeCacheObject: Duration(days: 7),
            maxNrOfCacheObjects: 100,
            fileFetcher: _customHttpGetter);

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }

  static Future<FileFetcherResponse> _customHttpGetter(String url,
      {Map<String, String> headers}) async {
    url = url.replaceAll(Config.AppBucket, '');
    StorageReference reference = FirebaseStorage.instance.ref().child(url);
    // Do things with headers, the url or whatever.
    print('!!! start get G url: $url');
    url = await reference.getDownloadURL();
    print('!!! end get G url: $url');
    return HttpFileFetcherResponse(await http.get(url, headers: headers));
  }
}

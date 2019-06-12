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

  static bool isFileProxy = true;

  factory CloudCacheManager() {
    if (_instance == null) {
      _instance = new CloudCacheManager._();
    }
    print('!!! CloudCacheManager factory');
    return _instance;
  }

  CloudCacheManager._() : super(key, fileFetcher: _customHttpGetter);

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }

  static Future<FileFetcherResponse> _customHttpGetter(String url,
      {Map<String, String> headers}) async {
    url = url.replaceAll(Config.AppBucket, '');
    StorageReference reference = FirebaseStorage.instance.ref().child(url);
    // Do things with headers, the url or whatever.
    if (isFileProxy) {
      //download the file first, and then link the file to the response, just want be fast.
      String newPath = Config.AppDirCache + url;
      File proxyFile = new File(newPath);
      bool exists = await proxyFile.exists();
      if (!exists) {
        await proxyFile.create(recursive: true);
      }
      var task = reference.writeToFile(proxyFile);
      var count = (await task.future).totalByteCount;

      http.Response _response =
          new http.Response.bytes(proxyFile.readAsBytesSync(), 200);
      return HttpFileFetcherResponse(_response);
    } else {
      //get getDownloadURL from http. and then download from http. too slow.
      url = await reference.getDownloadURL();
      return HttpFileFetcherResponse(await http.get(url, headers: headers));
    }
  }

//  @override
//  Future<FileInfo> downloadFile(String url,
//      {Map<String, String> authHeaders, bool force = false}) {
//    super.downloadFile(url);
//    print('!!! override downloadFile');
//    StorageReference reference = FirebaseStorage.instance.ref().child(url);
//    File(path)
//    reference.writeToFile(file);
//  }
//
//  @override
//  Future<File> getSingleFile(String url, {Map<String, String> headers}) {
//    // TODO: implement getSingleFile
//    return super.getSingleFile(url, headers);
//  }

}

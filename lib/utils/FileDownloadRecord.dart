import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sqflite/sql.dart';
import 'package:car_repair/base/conf.dart';
import 'DBHelp.dart';
import 'package:car_repair/utils/DBEntity/DownloadFile.dart';

import 'package:http/http.dart' as http;

class FileDownloadRecord {
  static getFileResponse(String url) async {
    //Query the DB, don't download twice.
    DownloadFile downloadFile = await QueryFile(url);
    File proxyFile;
    //If the file has been deleted.
    if (downloadFile != null) {
      print('!!! had file record. ${downloadFile.filePath}');
      proxyFile = File(downloadFile.filePath);
      if (!await proxyFile.exists()) {
        print('!!! file was delete, delete record.');
        deleteFile(downloadFile.fileUrl);
        downloadFile = null;
      }else
        print('!!! file had download, ok.');
    }

    //If the file is now in DB.
    if (downloadFile == null) {
      String newPath = Config.AppDirCache + url;
      proxyFile = new File(newPath);
      bool exists = await proxyFile.exists();
      if(exists){
        await proxyFile.delete();
      }
      if (!exists) {
        await proxyFile.create(recursive: true);
      }
      print('!!! create file ${proxyFile.absolute}');
      StorageReference reference = FirebaseStorage.instance.ref().child(url);
      print('!!! start download file. $url');
      var task = reference.writeToFile(proxyFile);
      print('!!! down load task start. ');
      var count = (await task.future).totalByteCount;
      //Save the file in DB.
      print('!!! download finish. count ${count}');
      insertFile(DownloadFile(url, newPath, count));
    }

    final String tempFileContents = String.fromCharCodes(proxyFile.readAsBytesSync());
    print('!!! read file as string.');
    http.Response _response = new http.Response(tempFileContents, 200);
    print('!!! make string to response.');
    return _response;
  }
}

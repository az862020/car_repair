import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sqflite/sql.dart';
import 'package:car_repair/base/conf.dart';
import 'DBHelp.dart';
import 'package:car_repair/utils/DBEntity/DownloadFile.dart';

import 'package:http/http.dart' as http;

class FileDownloadRecord {
  getFileResponse(String url) async {
    //Query the DB, don't download twice.
    DownloadFile downloadFile = await QueryFile(url);
    File proxyFile;
    //If the file has been deleted.
    if (downloadFile != null) {
      proxyFile = File(downloadFile.filePath);
      if (!await proxyFile.exists()) {
        deleteFile(downloadFile.fileUrl);
        downloadFile = null;
      }
    }

    //If the file is now in DB.
    if (downloadFile == null) {
      String newPath = Config.AppDirCache + url;
      proxyFile = new File(newPath);
      bool exists = await proxyFile.exists();
      if (!exists) {
        await proxyFile.create(recursive: true);
      }
      StorageReference reference = FirebaseStorage.instance.ref().child(url);
      var task = reference.writeToFile(proxyFile);
      var count = (await task.future).totalByteCount;
      //Save the file in DB.
      insertFile(DownloadFile(url, newPath, count));
    }

    final String tempFileContents = proxyFile.readAsStringSync();

    http.Response _response = new http.Response(tempFileContents, 200);
    return _response;
  }
}

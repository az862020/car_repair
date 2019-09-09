import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:car_repair/utils/DBEntity/DownloadFile.dart';
import 'package:car_repair/utils/DBEntity/UploadTask.dart';
import 'package:car_repair/utils/DBEntity/UploadEntity.dart';

import 'DBEntity/UploadTemp.dart';

final Future<Database> database = initDB();

final String DOWNLOADFILE = 'downloadfile';
final String UPLOADTASK = 'uploadTask';
final String UPLOADTEMP = 'uploadTemp';
final String UPLOADENTITY = 'uploadEntity';

Future<Database> initDB() async {
  var path = join(await getDatabasesPath(), 'car_repair.db');
  var db = await openDatabase(path, version: 1, onCreate: (db, version) async {
    await db.execute(
        "CREATE TABLE $DOWNLOADFILE (fileUrl TEXT PRIMARY KEY , filePath TEXT, fileLength INTEGER)");
    await db.execute(
        "CREATE TABLE $UPLOADTASK (tasktID INTEGER PRIMARY KEY autoincrement, type INTEGER, mediaType INTEGER, title TEXT, describe TEXT)");
    await db.execute(
        "CREATE TABLE $UPLOADTEMP (id INTEGER PRIMARY KEY autoincrement, tasktID INTEGER, filePath TEXT, isDone INTEGER, cloudPath TEXT)");
    await db.execute(
        "CREATE TABLE $UPLOADENTITY (localPath TEXT PRIMARY KEY , proxyPath TEXT, cloudPath TEXT, ext1 TEXT)");
    return db;
  });
  return db;
}

///***************** File *********************

Future<void> insertFile(DownloadFile file) async {
  final Database db = await database;

  await db.insert(DOWNLOADFILE, file.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<DownloadFile> QueryFile(String url) async {
  final db = await database;

  final List<Map<String, dynamic>> maps =
      await db.query(DOWNLOADFILE, where: 'fileUrl=?', whereArgs: [url]);
  if (maps.length > 0) return DownloadFile.fromMap(maps.first);
  return null;
}

Future<void> updateFile(DownloadFile file) async {
  final db = await database;
  await db.update(
    DOWNLOADFILE,
    file.toMap(),
    where: 'fileUrl = ?',
    whereArgs: [file.fileUrl],
  );
}

Future<void> deleteFile(String fileUrl) async {
  final db = await database;
  await db.delete(DOWNLOADFILE, where: 'fileUrl = ?', whereArgs: [fileUrl]);
}

///***************** File *********************

///***************** UploadTask *********************

Future<UploadTask> insertTask(UploadTask uploadtask) async {
  final Database db = await database;
  List<Map<String, dynamic>> data =
//  await db.query(UPLOADTASK,
//      where: 'title=?,describe=? ',
//      whereArgs: [uploadtask.title, uploadtask.describe]);
      await db.rawQuery(
          'select * from $UPLOADTASK where title=? and describe=?',
          [uploadtask.title, uploadtask.describe]);

  if (data.length > 0) {
    uploadtask.tasktID = data.first['tasktID'];
  } else {
    uploadtask.tasktID = await db.insert(UPLOADTASK, uploadtask.toMap());
  }
  return uploadtask;
}

Future<UploadTask> getTask(int taskID) async {
  final Database db = await database;
  List<Map<String, dynamic>> data =
      await db.query(UPLOADTASK, where: 'tasktID = ?', whereArgs: [taskID]);
  if (data.length > 0) {
    return UploadTask.fromMap(data.first);
  }
  return null;
}

Future<List<UploadTask>> queryAll() async {
  final Database db = await database;
  List<Map<String, dynamic>> maps = await db.query(UPLOADTASK);
  if (maps.length > 0) {
    List<UploadTask> data = List();
    for (var i = 0; i < maps.length; i++) {
      data.add(UploadTask.fromMap(maps[i]));
    }
    return data;
  }
  return null;
}

Future<void> deleteUploadTask(int taskID) async {
  final Database db = await database;
  db.delete(DOWNLOADFILE, where: 'tasktID = ?', whereArgs: [taskID]);
}

///***************** UploadTask *********************

///***************** UploadTemp *********************
Future<UploadTemp> insertUploadTemp(UploadTemp uploadTemp) async {
  final Database db = await database;
  uploadTemp.id = await db.insert(UPLOADTEMP, uploadTemp.toMap());
  return uploadTemp;
}

Future<Null> updateUploadTemp(UploadTemp uploadTemp) async {
  final Database db = await database;
  uploadTemp.id = await db.update(UPLOADTEMP, uploadTemp.toMap(),
      where: 'id = ?', whereArgs: [uploadTemp.id]);
  return uploadTemp;
}

Future<List<UploadTemp>> getUploadTemps(int taskID) async {
  final Database db = await database;
  List<Map<String, dynamic>> data =
      await db.query(UPLOADTEMP, where: 'tasktID = ?', whereArgs: [taskID]);
  List<UploadTemp> result = List();
  for (int i = 0; i < data.length; i++) {
    result.add(UploadTemp.fromMap(data.first));
  }
  return result;
}

///***************** UploadTemp *********************

///***************** UploadEntity *********************
Future<Null> insertUploadEntity(UploadEntity uploadEntity) async {
  final Database db = await database;
  List<Map<String, dynamic>> data = await db.query(UPLOADENTITY,
      where: 'localPath = ?', whereArgs: [uploadEntity.localPath]);
  if (data.length == 0) {
    print('!!! had insert a new record!');
    await db.insert(UPLOADENTITY, uploadEntity.toMap());
  }
}

Future<UploadEntity> getUploadEntity(String path) async {
  final Database db = await database;
  List<Map<String, dynamic>> data =
      await db.query(UPLOADENTITY, where: 'localPath = ?', whereArgs: [path]);
  if (data.length > 0) {
    return UploadEntity.fromMap(data.first);
  }
  return null;
}

Future<Null> updateUploadEntity(UploadEntity uploadEntity) async {
  final Database db = await database;
  await db.update(UPLOADENTITY, uploadEntity.toMap(),
      where: 'localPath = ?', whereArgs: [uploadEntity.localPath]);
}

///***************** UploadEntity *********************

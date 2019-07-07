import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:car_repair/utils/DBEntity/DownloadFile.dart';

final Future<Database> database = initDB();

final String DOWNLOADFILE = 'downloadfile';
final String UPLOADTASK = 'uploadTask';
final String UPLOADENTITY = 'uploadEntity';

Future<Database> initDB() async {
  var path = join(await getDatabasesPath(), 'car_repair.db');
  var db = await openDatabase(path, version: 1, onCreate: (db, version) {
    return db.execute(
        "CREATE TABLE $DOWNLOADFILE (fileUrl TEXT PRIMARY KEY , filePath TEXT, fileLength INTEGER); "
        "CREATE TABLE $UPLOADTASK (tasktID INTEGER PRIMARY KEY autoincrement, type INTEGER, title TEXT, describe TEXT); "
        "CREATE TABLE $UPLOADENTITY (localPath TEXT PRIMARY KEY , proxyPath TEXT, cloudPath TEXT, taskID INTEGER); "
        "");
  });
  return db;
}

Future<void> insertFile(DownloadFile file) async {
  final Database db = await database;

  await db.insert(DOWNLOADFILE, file.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<DownloadFile> QueryFile(String url) async {
  final db = await database;

  final List<Map<String, dynamic>> maps =
      await db.query(DOWNLOADFILE, where: 'fileUrl=?', whereArgs: [url]);
  if (maps.length > 0)
    return DownloadFile(
        maps[0]['fileUrl'], maps[0]['filePath'], maps[0]['fileLength']);
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

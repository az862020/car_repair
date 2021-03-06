import 'DBHelp.dart';
import 'DBEntity/UploadTask.dart';
import 'DBEntity/UploadTemp.dart';
import 'DBEntity/UploadEntity.dart';

class DBUtil {
  /// add a multi file upload task record to DB, and uploadTemp record.
  static addTask(List<String> paths, int type, int mediaType, String title,
      String describe, Function(List<UploadTemp>) callback) async {
    UploadTask task = UploadTask(type, mediaType, title, describe);
    print('!!! task $task');
    task = await insertTask(task);
    List<UploadTemp> temps = List();
    int entity = 0;
    for (int i = 0; i < paths.length; i++) {
      UploadTemp uploadTemp = UploadTemp(task.tasktID, paths[i], 0);
      insertUploadTemp(uploadTemp).then((temp) {
        temps.add(temp);
        if (temps.length == paths.length && entity == paths.length) {
          callback(temps);
        }
      });
      UploadEntity uploadEntity = UploadEntity(paths[i]);
      insertUploadEntity(uploadEntity).then((Null) {
        entity++;
        if (temps.length == paths.length && entity == paths.length) {
          callback(temps);
        }
      });
    }
  }

  static getTasks() {
    //TODO when app is start, should check DB.
    // if there is crash show down upload task.
  }

  static Future<bool> isTaskAllDone(int tasktID) async {
    List<UploadTemp> list = await getUploadTemps(tasktID);

    //this will be faster then old (every).
    return !list.any((temp) {
      return temp.isDone == 0;
    });
  }
}

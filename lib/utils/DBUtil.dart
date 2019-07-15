import 'DBHelp.dart';
import 'DBEntity/UploadTask.dart';
import 'DBEntity/UploadTemp.dart';
import 'DBEntity/UploadEntity.dart';

class DBUtil {
  /// add a multi file upload task record to DB, and uploadTemp record.
  static addTask(List<String> paths, int type, String title, String describe,
      Function(List<UploadTemp>) callback) async {
    UploadTask task = UploadTask(type, title, describe);
    task = await insertTask(task);
    List<UploadTemp> temps = List();
    int entity = 0;
    for (int i = 0; i < paths.length; i++) {
      UploadTemp uploadTemp = UploadTemp(task.tasktID, paths[i]);
      insertUploadTemp(uploadTemp).then((temp) {
        temps.add(temp);
        if (temps.length == paths.length && entity == paths.length) {
          callback(temps);
        }
      });
      UploadEntity uploadEntity = UploadEntity(paths[i], '', '', '');
      insertUploadEntity(uploadEntity).then((Null) {
        entity++;
        if (temps.length == paths.length && entity == paths.length) {
          callback(temps);
        }
      });
    }
  }

  static getTasks() {}
}

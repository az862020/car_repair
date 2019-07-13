/// UploadTemp, in the middle of task table and entity table.
/// record  task and entity mapping relationship
class UploadTemp {
  int id;
  int tasktID;
  String filePath;

  Map<String, dynamic> toMap() {
    var map = {
      'tasktID': tasktID,
      'filePath': filePath,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  UploadTemp.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    tasktID = map['tasktID'];
    filePath = map['filePath'];
  }

  @override
  String toString() {
    return 'UploadTask{id:$id, tasktID:$tasktID, filePath:$filePath}';
  }
}

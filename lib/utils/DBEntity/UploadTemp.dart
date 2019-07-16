/// UploadTemp, in the middle of task table and entity table.
/// record  task and entity mapping relationship
class UploadTemp {
  int id;
  int tasktID;
  String filePath;
  int isDone; //default is 0 means not done. when done is 1;
  String cloudPath;

  UploadTemp(this.tasktID, this.filePath, this.isDone,
      {this.id, this.cloudPath});

  Map<String, dynamic> toMap() {
    var map = {
      'tasktID': tasktID,
      'filePath': filePath,
      'isDone': isDone,
    };
    if (id != null) {
      map['id'] = id;
    }
    if (cloudPath != null) {
      map['cloudPath'] = cloudPath;
    }
    return map;
  }

  UploadTemp.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    tasktID = map['tasktID'];
    filePath = map['filePath'];
    isDone = map['isDone'];
    filePath = map['cloudPath'];
  }

  @override
  String toString() {
    return 'UploadTask{id:$id, tasktID:$tasktID, filePath:$filePath, isDone:$isDone, filePath:$filePath}';
  }
}

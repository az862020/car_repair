/// UploadTask, Mulite files upload. single upload entity 's papa.
class UploadTask {
  int tasktID;
  int type;
  String title;
  String describe;

  UploadTask(this.tasktID, this.type, this.title, this.describe);

  Map<String, dynamic> toMap() {
    var map = {
      'type': type,
      'title': title,
      'describe': describe,
    };
    if (tasktID != null) {
      map['tasktID'] = tasktID;
    }
    return map;
  }

  UploadTask.fromMap(Map<String, dynamic> map) {
    tasktID = map['tasktID'];
    type = map['type'];
    title = map['title'];
    describe = map['describe'];
  }

  @override
  String toString() {
    return 'UploadTask{tasktID:$tasktID, type:$type, title:$title, describe:$describe}';
  }
}

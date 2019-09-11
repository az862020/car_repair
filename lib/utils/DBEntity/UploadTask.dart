/// UploadTask, Mulite files upload. single upload entity 's papa.
class UploadTask {
  int tasktID;
  int type; //0: square
  int mediaType; //0: picture; 1:video
  String title;
  String describe;

  UploadTask(this.type, this.mediaType, this.title, this.describe,
      {this.tasktID});

  Map<String, dynamic> toMap() {
    var map = {
      'type': type,
      'mediaType': mediaType,
      'title': title,
      'describe': describe,
    };
    if (tasktID != null) {
      map['tasktID'] = tasktID;
    }
    return map;
  }

  UploadTask.fromMap(Map<String, dynamic> map) {
    if (map.containsKey('taskID')) tasktID = map['tasktID'];
    type = map['type'];
    mediaType = map['mediaType'];
    title = map['title'];
    describe = map['describe'];
  }

  @override
  String toString() {
    return 'UploadTask{tasktID:${tasktID ?? ''}, type:$type, title:$title, describe:$describe}';
  }
}

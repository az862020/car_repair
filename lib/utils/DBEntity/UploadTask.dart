/// UploadTask, Mulite files upload. single upload entity 's papa.
class UploadTask {
  final int tasktID;
  final int type;
  final String title;
  final String describe;

  UploadTask(this.tasktID, this.type, this.title, this.describe);

  @override
  String toString() {
    return 'UploadTask{tasktID:$tasktID, type:$type, title:$title, describe:$describe}';
  }
}

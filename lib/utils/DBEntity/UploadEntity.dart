/// upload file info in DB, just don't want download twice.
/// comperse, upload,
class UploadEntity {
  String localPath;
  String proxyPath;
  String cloudPath;
  String taskID;

  UploadEntity(this.localPath, this.proxyPath, this.cloudPath, this.taskID);

  Map<String, dynamic> toMap() {
    var map = {
      'localPath': localPath,
      'proxyPath': proxyPath,
      'cloudPath': cloudPath,
      'taskID': taskID,
    };
    return map;
  }

  UploadEntity.fromMap(Map<String, dynamic> map) {
    localPath = map['localPath'];
    proxyPath = map['proxyPath'];
    cloudPath = map['cloudPath'];
    taskID = map['taskID'];
  }

  @override
  String toString() {
    return 'File{localPath:$localPath, proxyPath:$proxyPath, cloudPath:$cloudPath, taskID:$taskID}';
  }
}

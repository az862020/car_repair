/// upload file info in DB, just don't want download twice.
/// comperse, upload,
class UploadEntity {
  final String localPath;
  final String proxyPath;
  final String cloudPath;
  final String taskID;

  UploadEntity(this.localPath, this.proxyPath, this.cloudPath, this.taskID);

  @override
  String toString() {
    return 'File{localPath:$localPath, proxyPath:$proxyPath, cloudPath:$cloudPath, taskID:$taskID}';
  }
}

/// upload file info in DB, just don't want download twice.
/// comperse, upload,
class UploadEntity {
  String localPath;
  String proxyPath;
  String cloudPath;
  String ext1;

  UploadEntity(this.localPath, this.proxyPath, this.cloudPath, this.ext1);

  Map<String, dynamic> toMap() {
    var map = {
      'localPath': localPath,
      'proxyPath': proxyPath,
      'cloudPath': cloudPath,
      'ext1': ext1,
    };
    return map;
  }

  UploadEntity.fromMap(Map<String, dynamic> map) {
    localPath = map['localPath'];
    proxyPath = map['proxyPath'];
    cloudPath = map['cloudPath'];
    ext1 = map['ext1'];
  }

  @override
  String toString() {
    return 'File{localPath:$localPath, proxyPath:$proxyPath, cloudPath:$cloudPath, ext1:$ext1}';
  }
}

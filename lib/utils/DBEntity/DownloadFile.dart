///download file info in DB, just don't want download twice.
class DownloadFile {
  String fileUrl;
  String filePath;
  int fileLength;

  DownloadFile(this.fileUrl, this.filePath, this.fileLength);

  Map<String, dynamic> toMap() {
    var map = {
      'fileUrl': fileUrl,
      'filePath': filePath,
      'fileLength': fileLength,
    };
    return map;
  }

  DownloadFile.fromMap(Map<String, dynamic> map) {
    fileUrl = map['fileUrl'];
    filePath = map['filePath'];
    fileLength = map['fileLength'];
  }

  @override
  String toString() {
    return 'File{fileUrl:$fileUrl, filePath:$filePath, fileLength:$fileLength}';
  }
}

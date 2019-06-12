///download file info in DB, just don't want download twice.
class DownloadFile {
  String fileUrl;
  String filePath;
  int fileLength;

  DownloadFile(this.fileUrl, this.filePath, this.fileLength, {int id});

  Map<String, dynamic> toMap() {
    var map = {
      'fileUrl': fileUrl,
      'filePath': filePath,
      'fileLength': fileLength,
    };
    return map;
  }

  @override
  String toString() {
    return 'File{fileUrl:$fileUrl, filePath:$filePath, fileLength:$fileLength}';
  }
}

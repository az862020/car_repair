import 'package:json_annotation/json_annotation.dart';

part 'UploadEntity.g.dart';

@JsonSerializable()
class UploadEntity {
  final String localPath;
  final String proxyPath;
  final String cloudPath;

  UploadEntity(this.localPath, this.proxyPath, this.cloudPath);
}

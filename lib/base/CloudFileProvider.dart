import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'dart:ui' as ui show Codec;
import 'dart:ui' show hashValues;

class CloudFileProvider extends ImageProvider<CloudFileProvider> {
  /// Creates an object that decodes a [File] as an image.
  ///
  /// The arguments must not be null.
  const CloudFileProvider(this.file, {this.scale = 1.0})
      : assert(file != null),
        assert(scale != null);

  /// The file to decode into an image.
  final File file;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  @override
  Future<CloudFileProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<CloudFileProvider>(this);
  }

  @override
  ImageStreamCompleter load(CloudFileProvider key) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key),
      scale: key.scale,
    );
  }

  Future<ui.Codec> _loadAsync(CloudFileProvider key) async {
    assert(key == this);

    final Uint8List bytes = await file.readAsBytes();
    if (bytes.lengthInBytes == 0) return null;

    return await PaintingBinding.instance.instantiateImageCodec(bytes);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final FileImage typedOther = other;
    return file?.path == typedOther.file?.path && scale == typedOther.scale;
  }

  @override
  int get hashCode => hashValues(file?.path, scale);

  @override
  String toString() => '$runtimeType("${file?.path}", scale: $scale)';
}

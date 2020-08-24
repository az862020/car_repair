import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

BuildContext _context;

class MyCropPage extends StatelessWidget {
  final String mTitle = 'Crop';

  String imgFilePath;

  MyCropPage(this.imgFilePath);

  @override
  Widget build(BuildContext context) {
    _context = context;

    return CropPage(mTitle, File(imgFilePath));
  }
}

class CropPage extends StatefulWidget {
  String mTitle = 'Crop';
  File imgFile;

  CropPage(this.mTitle, this.imgFile);

  @override
  State<StatefulWidget> createState() {
    return _CropPageState();
  }
}

class _CropPageState extends State<CropPage> {
  final cropKey = GlobalKey<CropState>(); //相当于裁剪控制器
  File _sample; //理解: 采样后的文件-相当于缩放后的.

  @override
  void initState() {
    super.initState();
    openImg();
  }

  @override
  void dispose() {
    _sample?.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mTitle),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(_context);
            }),
      ),
      body: Container(
        color: Colors.grey[200],
        child: _sample == null
            ? Crop(
                key: cropKey,
                maximumScale: 5.0,
                image: FileImage(widget.imgFile),
                aspectRatio: 3.0 / 3.0,
              )
            : Crop.file(
                _sample,
                key: cropKey,
                maximumScale: 5.0,
                aspectRatio: 3.0 / 3.0,
              ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          onPressed: () {
            startCrop().then((file) {
              Navigator.pop(_context, file);
            }).catchError((e) {
              print('!!! err : $e');
              Scaffold.of(context).showSnackBar(SnackBar(content: Text(e)));
            });
          }),
    );
  }

  openImg() async {
    final sample = await ImageCrop.sampleImage(
      file: widget.imgFile,
      preferredSize: context.size.longestSide.ceil(),
    );
    _sample?.delete();
    setState(() {
      _sample = sample;
    });
  }

  Future<File> startCrop() async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return null;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    _sample = await ImageCrop.sampleImage(
      file: widget.imgFile,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: _sample,
      area: area,
    );

    _sample.delete();
    debugPrint('!!! crop $file');
    return file;
  }
}

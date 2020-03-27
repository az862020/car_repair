import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:car_repair/utils/FireBaseUtils.dart';

import 'package:car_repair/Account/MyImagePick/MyCropPage.dart';


class MyImagePickerPage extends StatelessWidget {
  final String mTitle = 'ImagePicker';
  final FirebaseUser user;

  const MyImagePickerPage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImagePickerPage(mTitle, user);
  }
}

//bool isLoading = false;

class ImagePickerPage extends StatefulWidget {
  final String mTitle;
  final FirebaseUser user;

  ImagePickerPage(this.mTitle, this.user);

  @override
  State<StatefulWidget> createState() {
    return _MyImagePick();
  }
}

class _MyImagePick extends State<ImagePickerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mTitle),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          Offstage(
            offstage: _image == null,
            child: IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  // start upload.
                  uploadPic(context);
                }),
          ),
        ],
      ),
      body: Center(
          child: _image == null
              ? IconButton(
                  icon: Icon(
                    Icons.add_box,
                    color: Colors.blue,
                    size: 44.0,
                  ),
                  onPressed: () {
                    pickImage(context);
                  })
              : Image.file(_image)),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_box),
          onPressed: () {
            pickImage(context);
          }),
    );
  }

  Future<String> uploadPic(BuildContext context) async {
    FireBaseUtils.uploadPhotoUrl(
        context, _image, FireBaseUtils.STORAGE_PHOTOURL_PATH);
  }

  @override
  void dispose() {
    _image?.delete();
    _image = null;
    super.dispose();
  }
}

File _image;

pickImage(BuildContext context) async {
  ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
    if (file != null) {
      Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyCropPage(file)))
          .then((cropfile) async {
        debugPrint('!!! pick crop $cropfile ');
        _image?.delete();
        _image = null;
        _image = cropfile;
        String path = _image.absolute.path;
        path = path.substring(0, path.lastIndexOf('/') + 1);
        print('!!! get path $path');
        String newPath = '$path${DateTime.now().millisecondsSinceEpoch}.jpg';
        bool exists = await File(newPath).exists();
        if (!exists) {
          await File(newPath).create(recursive: true);
        }
        _image.rename(newPath).then((file) {
          _image = file;
        }).catchError((e) {
          print('!!! rename faile  $_image');
        });
      });
    }
  });
}

import 'dart:async';
import 'dart:io';

import 'package:car_repair/base/conf.dart';
import 'package:car_repair/widget/MyLoadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'MyCropPage.dart';

BuildContext _context;

class MyImagePickerPage extends StatelessWidget {
  final String mTitle = 'ImagePicker';
  final FirebaseUser user;

  const MyImagePickerPage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return ImagePickerPage(mTitle, user);
  }
}

bool isLoading = false;

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
              Navigator.pop(_context);
            }),
        actions: <Widget>[
          Offstage(
            offstage: _image == null,
            child: IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  // start upload.

                  uploadPic();
//                  Navigator.pop(_context, _image);
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

  Future<String> uploadPic() async {
    if (isLoading) return '';

    var dialog = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return MyLoadingDialog();
        });

    String path = _image.absolute.path;
    String name = path.substring(path.lastIndexOf('/') + 1);
    path = path.substring(path.lastIndexOf('/'));

    String url = 'userinfo/photoUrl/${widget.user.uid}';
    print('!!! url $url');
    print('!!! img $_image');

//    final StorageReference reference =
//        Config.storage
//        .ref()
//        .child('userinfo')
//        .child('photoUrl')
//        .child('${widget.user.uid}')
//        .child(name);
//    print('!!! ref ${reference.path}');
////    FirebaseStorage.instance
////        .getReferenceFromUrl(url)
////        .then((reference) {
//
//      StorageUploadTask task = reference
//          .putFile(
//              _image,
//              StorageMetadata(
//                contentType: 'image/jpeg',
////                customMetadata: <String, String>{'type': 'image/jpeg'},
//              ));
//      StorageTaskSnapshot snapshot = await task.onComplete;
//      String upUrl = await snapshot.ref.getDownloadURL();
//      print('!!! onComplete $upUrl');
//          .events
//          .listen((dataEvent) {
//            print('!!! ${dataEvent.type}');
//      }, onDone: () {
//        print('!!! onDone  ${reference.path}');

//      }, onError: (){
//        print('!!! onError  ${reference.path}');
//
//      });
//      }
//      );

    bool isLoad = false;
    var reference = FirebaseStorage.instance.ref().child(url).child(name);
    reference.putFile(_image).events.listen((event) {
      if (event == StorageTaskEventType.success ||
          event == StorageTaskEventType.failure ||
          event == StorageTaskEventType.pause) {
        // stop upload.
        isLoad = false;
        if (event == StorageTaskEventType.success) {
          updateWhenUpload(
              dialog, Config.storage.storageBucket + reference.path);
        } else if (event == StorageTaskEventType.failure) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Upload failure.')));

          Navigator.of(dialog).pop();
        }
      } else if (event == StorageTaskEventType.progress) {
        var snapshot = event.snapshot;
        print('!!! ${snapshot.bytesTransferred} / ${snapshot.totalByteCount}');
        var procent = snapshot.bytesTransferred / snapshot.totalByteCount * 100;
        print('!!! $procent%');
        isLoad = true;
      }
      if (isLoad != isLoading) {
        setState(() {
          isLoading = isLoad;
        });
      }
    });
  }

  updateWhenUpload(BuildContext dialog, String referencePath) {
    print('!!! update url to user $referencePath}');
    UserUpdateInfo info = UserUpdateInfo();
    info.photoUrl = referencePath;
    widget.user.updateProfile(info).then((result) {
      print('!!! updateProfile.');
      Navigator.of(dialog).pop();
    }).catchError((e) {});
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
        String newPath = '${path}${DateTime.now().millisecondsSinceEpoch}.jpg';
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

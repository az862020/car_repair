import 'dart:async';
import 'dart:io';

import 'package:car_repair/base/conf.dart';
import 'package:car_repair/widget/MyLoadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:car_repair/utils/FireBaseUtils.dart';

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

//    if (isLoading) return '';
//
//    String path = _image.absolute.path;
//    String name = path.substring(path.lastIndexOf('/') + 1);
//    path = path.substring(path.lastIndexOf('/'));
//
//    String url = 'userinfo/photoUrl/${widget.user.uid}';
//    print('!!! url $url');
//    print('!!! img $_image');
//
//    bool isLoad = false;
//    var reference = FirebaseStorage.instance.ref().child(url).child(name);
//    reference.putFile(_image).events.listen((event) {
//      print('!!! event ${event.type}');
//      if (event.type == StorageTaskEventType.success ||
//          event.type == StorageTaskEventType.failure ||
//          event.type == StorageTaskEventType.pause) {
//        // stop upload.
//        isLoad = false;
//        if (event.type == StorageTaskEventType.success) {
//          updateWhenUpload(
//              context, Config.storage.storageBucket + reference.path);
//        } else if (event.type == StorageTaskEventType.failure) {
//          Navigator.pop(context, 'dialog');
//          Scaffold.of(context)
//              .showSnackBar(SnackBar(content: Text('Upload failure.')));
//        }
//      } else if (event.type == StorageTaskEventType.progress) {
//        var snapshot = event.snapshot;
//        print('!!! ${snapshot.bytesTransferred} / ${snapshot.totalByteCount}');
//        var procent = snapshot.bytesTransferred / snapshot.totalByteCount * 100;
//        print('!!! $procent%');
//        isLoad = true;
//      }
//      if (isLoad != isLoading) {
//        setState(() {
//          isLoading = isLoad;
//        });
//      }
//    });
//    Config.showLoadingDialog(context);
  }

//  updateWhenUpload(BuildContext dialog, String referencePath) {
//    print('!!! update url to user $referencePath');
//    FireBaseUtils.updatePhotoUrl(referencePath, FireBaseUtils.PHOTOURL)
//        .then((user) {
//      Navigator.of(dialog, rootNavigator: true).pop(user);
//      Navigator.of(dialog).pop(user);
//    });

//    UserUpdateInfo info = UserUpdateInfo();
//    info.photoUrl = referencePath;
//    info.displayName = widget.user.displayName == null
//        ? widget.user.email
//        : widget.user.displayName;
//    widget.user.updateProfile(info).then((result) {
//      print('!!! updateProfile. photoUrl:${widget.user.photoUrl}');
//      widget.user.reload().then((x) {
//        print('!!! updateProfile. photoUrl:${widget.user.photoUrl}');
//        FirebaseAuth.instance.currentUser().then((user) {
//          Config.user = user;
//          print('!!! updateProfile. photoUrl:${user.photoUrl}');
//          Navigator.of(dialog, rootNavigator: true).pop(user);
//          Navigator.of(dialog).pop(user);
//        });
//      });
//    }).catchError((e) {});
//  }

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

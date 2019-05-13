import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'MyCropPage.dart';



BuildContext _context;
class MyImagePickerPage extends StatelessWidget {
  final String mTitle = 'ImagePicker';

  @override
  Widget build(BuildContext context) {
    _context = context;
//    return MaterialApp(
//      title: mTitle,
//      home: ImagePickerPage(mTitle),
//    );
    return ImagePickerPage(mTitle);
  }
}

class ImagePickerPage extends StatefulWidget {
  final String mTitle;

  ImagePickerPage(this.mTitle);

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
                  //TODO start upload.
                  Navigator.pop(_context, _image);


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


}

  File _image;
  pickImage(BuildContext context) async {
    ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
      if (file != null) {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyCropPage(file)))
            .then((cropfile) {
          debugPrint('!!! pick crop $cropfile ');
          _image?.delete();
          _image = null;
          _image = cropfile;
        }).catchError((e) {
          debugPrint('!!! crop error $e ');
        });
      }
    }).catchError((e) {
      debugPrint('!!! pick error $e');
    });
  }

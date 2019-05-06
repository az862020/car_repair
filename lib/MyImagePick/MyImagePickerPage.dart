import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePickerPage extends StatelessWidget {
  final String mTitle = 'ImagePicker';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: mTitle,
      home: ImagePickerPage(mTitle),
    );
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
  File _image;

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
                  //TODO finish image pick.

                  Navigator.pop(context, _image);
                }),
          ),
        ],
      ),
      body: Center(
          child: _image == null ?
          IconButton(icon: Icon(Icons.add_box, color: Colors.blue, size: 44.0,),
              onPressed: () {
                pickImage();
              }) :
          Image.file(_image)
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_box),
          onPressed: () {
            pickImage();
          }),
    );
  }

  pickImage() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }
}

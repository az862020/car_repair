import 'dart:io';

import 'package:car_repair/base/conf.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_jpeg/image_jpeg.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';

class MyNewPublishPage extends StatelessWidget {
  final String mTitle = 'MyNewPublishPage';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: mTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(mTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: MyNewPublish(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.publish), onPressed: () => publish()),
      ),
    );
  }
}

publish() {
  //1. TODO compression
  //2. TODO upload
}

class MyNewPublish extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyNewPublishState();
  }
}

var titleControl = TextEditingController();
var describeControl = TextEditingController();
//var pics = List<String>();
var photoPathList = List<AssetEntity>();
//var video = '';

class _MyNewPublishState extends State<MyNewPublish> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        TextFormField(
          controller: titleControl,
          decoration:
              InputDecoration(hintText: "This is title. Empty is allow."),
        ),
        Expanded(
          flex: 1,
          child: GridView.builder(
              itemCount: 9,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 1.0),
              itemBuilder: (context, index) {
                if (index == photoPathList.length) {
                  return Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: IconButton(
                        iconSize: 48,
                        icon: Icon(Icons.add_photo_alternate),
                        onPressed: () {
//            add();
                          pickAsset();
                        }),
                  );
                } else if (index > photoPathList.length) {
                  return Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  );
                } else {
                  return GestureDetector(
                    child: Image.file(File(photoPathList[index].id)),
                    onTap: () {
                      preview();
                    },
                    onLongPress: () {
//          alertDelete();
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('R U sure?'),
                                content:
                                    Text('Are you sure you want to delete it?'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Cancle'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('Delete'),
                                    onPressed: () {
                                      setState(() {
                                        photoPathList.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ));
                    },
                  );
                }
              }),
        ),
        TextFormField(
          controller: titleControl,
          decoration:
              InputDecoration(hintText: "This is describe. Empty is allow."),
        ),
      ],
    );
  }

//  add() async {
////    ImagePicker.pickVideo(source: ImageSource.gallery);
//    //TODO maybe user wanna add a video. so I should diff their choose: pic / video
//
//    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//    if (file != null) {
//      String jpegPath =
//          '${Config.AppDirCache}${DateTime.now().millisecondsSinceEpoch}.jpg';
//      await ImageJpeg.encodeJpeg(file.path, jpegPath, 80, 1920, 1080);
//      setState(() {
//        pics.add(jpegPath);
//      });
//    }
//  }

  void preview() {
    print('!!! preview!');
    //TODO preview.
  }

  void pickAsset() async {
    var result = await PhotoPicker.pickAsset(
      context: context,

      /// The following are optional parameters.
      themeColor: Colors.blue,
      // the title color and bottom color
      provider: I18nProvider.english,
      // i18n provider ,default is chinese. , you can custom I18nProvider or use ENProvider()
      textColor: Colors.white,
      sortDelegate: SortDelegate.common,
      // default is common ,or you make custom delegate to sort your gallery
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.white,
        unselectedColor: Colors.white,
        checkColor: Colors.blue,
      ),
      pickType: PickType.all,
    );
    if (result.length > 0) {
      setState(() {
        photoPathList = result;
      });
    }
  }
}

import 'dart:io';

import 'package:car_repair/base/Config.dart';
import 'package:flutter/material.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:car_repair/utils/FileUploadRecord.dart';

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
            child: Icon(Icons.publish),
            onPressed: () => publish(context, radioValue)),
      ),
    );
  }
}

publish(BuildContext context, var radioValue) async {
  //1.  compression
  if (photoPathList.length > 0) {
    Config.showLoadingDialog(context);
    uploadFiles.clear();
    uploadFiles
        .addAll(photoPathList.map((assetEntity) => assetEntity.id).toList());
    FileUploadRecord.uploadFiles(
        context,
        uploadFiles,
        FileUploadRecord.mediaType_picture,
        FileUploadRecord.type_square,
        titleControl.text,
        describeControl.text,
        radioValue, done: (ok) {
      Navigator.of(context, rootNavigator: true).pop();

      if (ok) {
        print('!!! 上传成功');
        Navigator.pop(context);
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('上传失败')));
      }
    });
  } else {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('暂不支持没有图片或者视频.')));
  }
}

class MyNewPublish extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyNewPublishState();
  }
}

var titleControl = TextEditingController();
var describeControl = TextEditingController();
var photoPathList = List<AssetEntity>();
var uploadFiles = List<String>();
BuildContext mContext;
var radioValue = 'default';

class _MyNewPublishState extends State<MyNewPublish> {
  @override
  void initState() {
    titleControl = TextEditingController();
    describeControl = TextEditingController();
    photoPathList = List<AssetEntity>();
    uploadFiles = List<String>();
    radioValue = 'default';
    super.initState();
  }

  @override
  void dispose() {
    titleControl.dispose();
    describeControl.dispose();
    photoPathList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(30.0, 5, 30, 15),
          child: TextFormField(
            controller: titleControl,
            decoration:
                InputDecoration(hintText: "This is title. Empty is allow."),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RadioListTile<String>(
              value: 'default',
              title: Text('default'),
              groupValue: radioValue,
              onChanged: (i) => updateRadio,
            ),
            RadioListTile(
              value: 'New',
              title: Text('New'),
              groupValue: radioValue,
              onChanged: (i) => updateRadio,
            ),
          ],
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.symmetric(vertical: 15.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            child: GridView.builder(
              itemCount: 9,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 1.0),
              itemBuilder: _gridItemBuild,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.fromLTRB(10.0, 5, 10, 15),
            child: TextFormField(
              controller: describeControl,
              decoration: InputDecoration(
                  hintText: "This is describe. Empty is allow."),
            ),
          ),
        ),
      ],
    );
  }

  Widget _gridItemBuild(context, index) {
    if (index == photoPathList.length) {
      return Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.grey[350],
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
          color: Colors.grey[350],
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
                    content: Text('Are you sure you want to delete it?'),
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
                            _getpicNameToTitle();
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  ));
        },
      );
    }
  }

  void updateRadio(var i) {
    radioValue = i;
    setState(() {
      radioValue = i;
    });
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
      rowCount: 3,

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
        _getpicNameToTitle();
      });
    }
  }

  _getpicNameToTitle() async {
    if (photoPathList.length == 0) {
      titleControl.text = '';
    } else {
      var filename = photoPathList.first.id.split('/').last.split(".").first;
      titleControl.text = filename;
    }
  }
}

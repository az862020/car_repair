import 'dart:io';

import 'package:car_repair/Account/MyImagePick/MyCropPage.dart';
import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/base/Config.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/fire_user_info_entity.dart';
import 'package:car_repair/utils/FireBaseUtils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyEditDisplayNamePage extends StatelessWidget {
  final String mTitle = 'EditDisplay';

  @override
  Widget build(BuildContext context) {
    var edit = EditDisplayNamePage();

    return Scaffold(
      appBar: AppBar(
        title: Text(mTitle),
      ),
      body: edit,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.cloud_done),
          onPressed: () => edit.updateUserDetails(context)),
    );
  }
}

class EditDisplayNamePage extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final displayNameControler = TextEditingController();
  final sexControler = TextEditingController();
  final countryControler = TextEditingController();
  final provinceControler = TextEditingController();
  final signatureControler = TextEditingController();

  File _image;

  @override
  State<StatefulWidget> createState() {
    return _EditDisplayName();
  }

  uploadBackgroundPhoto(BuildContext context) {
    FireBaseUtils.uploadPhotoUrl(
        context, _image, FireBaseUtils.STORAGE_BACKGROUND_PATH,
        done: (isOK, {String url}) {
      if (isOK) {
        updateUserDetails(context, bg: url);
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Upload background photo failed! try later plz.')));
      }
    });
  }

  updateUserDetails(BuildContext context, {String bg}) async {
    //1.write data in firestore
    if (!formKey.currentState.validate()) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('displayName can\'t be empty.')));
      return;
    }

    //check and make sure backgroud photo has a url.
    if (_image != null && bg == null) {
      uploadBackgroundPhoto(context);
      return;
    }

    Config.showLoadingDialog(context);
    FireUserInfoEntity info =
        FireUserInfoEntity().fromJson(Config.userInfo.toJson());
    info.displayName = displayNameControler.text;
    info.sex = sexControler.text;
    info.country = countryControler.text;
    info.province = provinceControler.text;
    info.signature = signatureControler.text;
    if (bg != null) info.backgroundPhoto = bg;

    await FireStoreUtils.updateUserinfoByUser(info).catchError((e) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Update failed! try later plz.')));
      Navigator.of(context, rootNavigator: true).pop();
      return;
    });

    //2.write data in fireAuth if need.
    if (Config.userInfo.displayName != displayNameControler.text) {
      await Config.user.updateProfile(displayName: displayNameControler.text);
    }

    await FireBaseUtils.updateUserInfoDetails(info);
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.pop(context);
  }
}

class _EditDisplayName extends State<EditDisplayNamePage> {
  @override
  void initState() {
    super.initState();
    setState(() {
      widget.displayNameControler.text = Config.userInfo.displayName;
      widget.sexControler.text = Config.userInfo.sex ?? '';
      widget.countryControler.text = Config.userInfo.country ?? '';
      widget.provinceControler.text = Config.userInfo.province ?? '';
      widget.signatureControler.text = Config.userInfo.signature ?? '';
    });
  }

  @override
  void dispose() {
    widget._image?.delete();
    widget._image = null;
    widget.displayNameControler.dispose();
    widget.sexControler.dispose();
    widget.countryControler.dispose();
    widget.provinceControler.dispose();
    widget.signatureControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                pickImage(context);
                print('!!! change background image.');
              },
              child: Container(
                  height: 250,
                  color: Colors.blue,
                  child: widget._image == null
                      ? (Config.userInfo.backgroundPhoto == null ||
                              Config.userInfo.backgroundPhoto.isEmpty
                          ? Container()
                          : Image(
                              image: CloudImageProvider(
                                  Config.userInfo.backgroundPhoto)))
                      : Image.file(widget._image)),
            ),
            GestureDetector(
              onTap: () {
                pickImage(context);
                print('!!! change background image.');
              },
              child: Text('Background photo')
            ),
            Container(height: 15),
            TextFormField(
              controller: widget.displayNameControler,
              validator: (string) {
                if (string.isEmpty) return 'displayName can\'t be empty.';
                return null;
              },
              decoration: InputDecoration(
                  labelText: 'Enter your displayName',
                  hintText: 'Just can not be empty',
                  icon: Icon(Icons.insert_emoticon)),
            ),
            Container(height: 15),
            TextFormField(
              controller: widget.sexControler,
              decoration: InputDecoration(
                  labelText: 'Enter your gender',
                  hintText: 'male, female, or any others',
                  icon: Icon(Icons.wc)),
            ),
            Container(height: 15),
            TextFormField(
              controller: widget.countryControler,
              decoration: InputDecoration(
                  labelText: 'Enter your country',
                  hintText: 'can be anything',
                  icon: Icon(Icons.public)),
            ),
            Container(height: 15),
            TextFormField(
              controller: widget.provinceControler,
              decoration: InputDecoration(
                  labelText: 'Enter your province',
                  hintText: 'can be anything',
                  icon: Icon(Icons.map)),
            ),
            Container(height: 15),
            TextFormField(
              controller: widget.signatureControler,
              decoration: InputDecoration(
                  labelText: 'Enter your signature or slogan',
                  hintText: 'can be anything',
                  icon: Icon(Icons.reorder)),
            ),
            Container(height: 15),
          ],
        ),
      ),
    );
  }

  pickImage(BuildContext context) async {
    ImagePicker().getImage(source: ImageSource.gallery).then((file) {
      if (file != null) {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyCropPage(file.path)))
            .then((cropfile) async {
          debugPrint('!!! pick crop $cropfile ');
          widget._image?.delete();
          widget._image = null;
          widget._image = cropfile;
          String path = widget._image.absolute.path;
          path = path.substring(0, path.lastIndexOf('/') + 1);
          print('!!! get path $path');

          String newPath = '$path${DateTime.now().millisecondsSinceEpoch}.jpg';
          bool exists = await File(newPath).exists();
          if (!exists) {
            await File(newPath).create(recursive: true);
          }
          widget._image.rename(newPath).then((file) {
            setState(() {
              widget._image = file;
            });
          }).catchError((e) {
            print('!!! rename faile  ${widget._image}');
          });
        });
      }
    });
  }
}

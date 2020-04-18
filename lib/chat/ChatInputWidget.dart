

import 'package:car_repair/base/Config.dart';
import 'package:car_repair/publish/MyNewPublishPage.dart';
import 'package:car_repair/utils/FileUploadRecord.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo/photo.dart';

class ChatInputWidget extends StatefulWidget{

  Function(String content, int type) sendMessage;
  FocusNode focusNode;
  Function() showSticker;

  ChatInputWidget(this.sendMessage, this.focusNode, this.showSticker);

  @override
  State<StatefulWidget> createState() {
    return _chatInputWidget();
  }

}

class _chatInputWidget extends State<ChatInputWidget>{

  final TextEditingController textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: ()=>getImage(context),
//                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.face),
                onPressed: getSticker,
//                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
//                  hintStyle: TextStyle(color: greyColor),
                ),
                focusNode: widget.focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => widget.sendMessage(textEditingController.text, 0),
//                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
          new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    widget.focusNode.unfocus();
    setState(() {
      widget.showSticker();
    });
  }

   getImage(BuildContext context) async{
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
      for(int i = 0; i<result.length; i++){
        print('!!! IMG MSG ${result[i]}');
        List<String> photos = List();
        photos.add(result[i].id);
        FileUploadRecord.uploadFiles(context, photos, 1, 0, '', result[i].id, Config.user.uid, done2: (coludPath){
          widget.sendMessage(coludPath, 1);
        });
      }
    }
  }

}
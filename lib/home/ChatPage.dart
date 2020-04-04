import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/base/conf.dart';
import 'package:car_repair/entity/conversation_entity.dart';
import 'package:car_repair/entity/fire_message_entity.dart';
import 'package:car_repair/event/StartChatEvent.dart';
import 'package:car_repair/generated/json/fire_message_entity_helper.dart';
import 'package:car_repair/home/MessageItem.dart';
import 'package:car_repair/widget/AvatarWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_utils/common_utils.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  String mTitle = 'CHAT';

  ConversationEntity conversation;
  String conversationName;

  ChatPage(this.conversation, this.conversationName);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: mTitle,
      home: Scaffold(
        appBar: AppBar(
          title: AvatarWidget(conversation.id, conversation: conversation,),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ChatPageState(conversation),
      ),
    );
  }
}

class ChatPageState extends StatefulWidget {
  ConversationEntity conversation;

  ChatPageState(this.conversation);

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPageState> {
  Stream<QuerySnapshot> dataStream;

  bool isShowSticker = false;
  bool isLoading = false;
  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    isLoading = false;
    isShowSticker = false;
    focusNode.addListener(onFocusChange);
    dataStream = FireStoreUtils.getMessageList(widget.conversation.id);
  }

  @override
  void dispose() {
    EventBus().fire(StartChatEvent()); //send a event to home. want show chat.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Sticker
              (isShowSticker ? buildSticker() : Container()),

              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  buildListMessage() {
    return Flexible(
        child: StreamBuilder(
            stream: dataStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return LinearProgressIndicator();
              if (snapshot.connectionState == ConnectionState.none)
                return Center(
                    child: Text(
                  'No data!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ));
              return _buildList(context, snapshot.data.documents);
            }));
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return RefreshIndicator(
        onRefresh: () {
          setState(() {
            dataStream = FireStoreUtils.getMessageList(widget.conversation.id);
          });
        },
        child: ListView.builder(
            itemCount: snapshot.length,
            reverse: true,
            controller: listScrollController,
            itemBuilder: (context, i) {
              if (i > snapshot.length || snapshot.length == 0) return null;
//          if (i == snapshot.length) return BottomMore.getMoreWidget(isEnd);
              var entity = fireMessageEntityFromJson(
                  FireMessageEntity(), snapshot[i].data);
              return MessageItem(entity, widget.conversation, i == 0 );
            }));
  }

  buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: getImage,
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
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
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

  buildSticker() {}

  buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  void getImage() {}

  onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      FireMessageEntity msg = FireMessageEntity();
      msg.sendID = Config.user.uid;
      msg.content = content;
      msg.type = type;
      msg.time = DateUtil.getNowDateMs();

      FireStoreUtils.addMessageToConversation(widget.conversation.id, msg)
          .then((Null) {
        listScrollController.animateTo(0.0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Nothing to send...')));
    }
  }
}
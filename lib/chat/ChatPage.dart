import 'package:car_repair/base/Events.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/base/Config.dart';
import 'package:car_repair/chat/ChatInputWidget.dart';
import 'package:car_repair/entity/conversation_entity.dart';
import 'package:car_repair/entity/fire_message_entity.dart';
import 'package:car_repair/generated/json/fire_message_entity_helper.dart';
import 'ChatStickerWidget.dart';
import 'package:car_repair/widget/AvatarWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_utils/common_utils.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MessageItem.dart';

class ChatPage extends StatelessWidget {
  String mTitle = 'CHAT';

  ConversationEntity conversation;
  String conversationName;
  String conversationPhoto;

  ChatPage(this.conversation, this.conversationName, this.conversationPhoto);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: mTitle,
      theme: ThemeData(scaffoldBackgroundColor: Colors.grey[300]),
      home: Scaffold(
        appBar: AppBar(
          title: AvatarWidget(
            conversation.id,
            conversation: conversation,
            donotClick: true,
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ChatPageState(conversation, context, conversationName),
      ),
    );
  }
}

class ChatPageState extends StatefulWidget {
  ConversationEntity conversation;
  BuildContext buildContext;
  String conversationName;

  ChatPageState(this.conversation, this.buildContext, this.conversationName);

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
  FireMessageEntity lastMsg;

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
    print('!!! there is last msg check');
    if (lastMsg != null) {
      print('!!! there is last msg update conversation.');
      FireStoreUtils.updateConversation(
          widget.conversation, widget.conversationName, lastMsg);
    }
    eventBus.fire(StartChatEvent()); //send a event to home. want show chat.
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
              (isShowSticker
                  ? ChatStickerWidget(onSendMessage, focusNode, isShowSticker)
                  : Container()),

              // Input content
              ChatInputWidget(onSendMessage, focusNode, getSticker),
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
    print('!!! back in chat page');
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  buildListMessage() {
    return Flexible(
        child: Padding(
      padding: EdgeInsets.all(5.0),
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
          }),
    ));
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
              FireMessageEntity entity = fireMessageEntityFromJson(
                  FireMessageEntity(), snapshot[i].data);
              entity.id = snapshot[i].documentID;
              FireMessageEntity entity2 = null;

              bool isLast = (i == snapshot.length - 1);
              if (!isLast) {
                entity2 = fireMessageEntityFromJson(
                    FireMessageEntity(), snapshot[i + 1].data);
                entity2.id = snapshot[i + 1].documentID;
                if (entity.sendID != entity2.sendID) isLast = true;
              }
              if (i == 0) lastMsg = entity;
              return MessageItem(
                  entity, widget.conversation, entity2, widget.buildContext);
            }));
  }

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
          .then((value) {
        listScrollController.animateTo(0.0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }).then((value) {
        FireStoreUtils.updateConversation(
            widget.conversation, widget.conversationName, msg);
      });
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Nothing to send...')));
    }
  }
}

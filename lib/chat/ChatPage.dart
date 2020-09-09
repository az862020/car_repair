import 'package:car_repair/base/Events.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/base/Config.dart';
import 'package:car_repair/chat/ChatInputWidget.dart';
import 'package:car_repair/entity/conversation_entity.dart';
import 'package:car_repair/entity/fire_message_entity.dart';
import 'package:car_repair/entity/user_infor_entity.dart';
import 'package:car_repair/generated/json/fire_message_entity_helper.dart';
import 'package:car_repair/utils/UserInfoManager.dart';
import 'ChatStickerWidget.dart';
import 'package:car_repair/widget/AvatarWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:car_repair/utils/DBHelp.dart';

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
      home: ChatPageState(conversation, context, conversationName),
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
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();
  FireMessageEntity lastMsg;
  ChatInputWidget chatInputWidget;
  UserInforEntity userInforEntity;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    isShowSticker = false;
    focusNode.addListener(onFocusChange);
    dataStream = FireStoreUtils.getMessageList(widget.conversation.id);
    chatInputWidget = ChatInputWidget(onSendMessage, focusNode, getSticker);
    _loadUserShip();
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
    return Scaffold(
      appBar: AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          AvatarWidget(
            widget.conversation.id,
            conversation: widget.conversation,
//                click: true,
          ),
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () => goDetails(context),
          )
        ]),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(widget.buildContext)),
      ),
      body: WillPopScope(
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
                chatInputWidget,
              ],
            ),
            buildLoading(),
            buildAddFriendTip()
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  goDetails(BuildContext context) async {
    if (widget.conversation.chattype == 0) {
      if (userInforEntity != null) {
        //todo goto user ship set page. remove friend or remark display name.
        print('!!! here should goto details.');
      }
    } else {}
  }

  Future<bool> onBackPress() {
    print('!!! back in chat page');
    if (isShowSticker)
      setState(() => isShowSticker = false);
    else
      Navigator.pop(context);
    return Future.value(false);
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() => isShowSticker = false);
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
            return _buildList(context, snapshot.data.docs);
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
                  FireMessageEntity(), snapshot[i].data());
              entity.id = snapshot[i].id;
              FireMessageEntity entity2;

              bool isLast = (i == snapshot.length - 1);
              if (!isLast) {
                entity2 = fireMessageEntityFromJson(
                    FireMessageEntity(), snapshot[i + 1].data());
                entity2.id = snapshot[i + 1].id;
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

  buildAddFriendTip() {
    return Positioned(
      child: (userInforEntity != null && userInforEntity.isFriend != 0)
          ? Container(
              padding: EdgeInsets.only(left: 20.0, right: 10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add Friend'),
                    IconButton(
                        icon: Icon(Icons.person_add),
                        onPressed: () => _sendAddFriend())
                  ]),
              color: Colors.white,
            )
          : Container(),
    );
  }

  _loadUserShip() {
    if (widget.conversation.chattype == 0) {
      List<String> ids = List();
      ids.addAll(widget.conversation.user);
      ids.remove(Config.user.uid);
      UserInfoManager.getUserInfo(ids.first).then((userShip) {
        if (userShip.isFriend != 1) {
          setState(() {
            userInforEntity = userShip;
          });
        }
      });
    }
  }

  _sendAddFriend() {
    print('!!! here send add friend request.');
    Config.showLoadingDialog(context);
    UserInfoManager.operatiorUser(userInforEntity, friend: true).then((value) {
      Navigator.of(context).pop();
      setState(() {
        print('!!! add friend ok  ');
        userInforEntity.isFriend = 1;
      });
      cacheUserInfor(userInforEntity);
    }).catchError((e) {
      Navigator.of(context).pop();
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e)));
    });
  }

  onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      FireMessageEntity msg = FireMessageEntity();
      msg.sendID = Config.user.uid;
      msg.content = content;
      msg.type = type;
      msg.time = DateUtil.getNowDateMs();

      FireStoreUtils.addMessageToConversation(widget.conversation.id, msg)
          .catchError((e) =>
              Scaffold.of(context).showSnackBar(SnackBar(content: Text(e))))
          .then((value) {
        chatInputWidget.cleanText();
        listScrollController.animateTo(0.0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
        FireStoreUtils.updateConversation(
            widget.conversation, widget.conversationName, msg);
      });
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Nothing to send...')));
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:car_repair/chat/Emoji.dart';
import 'package:car_repair/chat/EmojiList.dart';

class ChatStickerWidget extends StatefulWidget {
  Function(String content, int type) sendMessage;
  FocusNode focusNode;
  bool isShowSticker;

  ChatStickerWidget(this.sendMessage, this.focusNode, this.isShowSticker);

  @override
  State<StatefulWidget> createState() {
    return _chatStickerWidget();
  }
}


class _chatStickerWidget extends State<ChatStickerWidget>
    with SingleTickerProviderStateMixin {
  List<Emoji> tabs = List();
  List<Widget> tabViews=List();
  TabController _tabController;



  @override
  void initState() {
    super.initState();
    initTab();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            child: TabBar(
              labelColor: Colors.blue,
                controller: _tabController,
                tabs: tabs.map((e) => Tab(text: e.name, )).toList()),
          ),

          Flexible(
            child: Container(
              child: TabBarView(
                controller: _tabController,
                children: tabViews.toList(),
              ),
            ),
          )

        ],
      ),
    );
  }

  void initTab() {
    tabs.clear();
    tabs.add(Emoji('3D', 15));
    tabs.add(Emoji('POWER', 20));

    tabViews.clear();
    for(int i = 0; i<tabs.length; i++){
      tabViews.add(EmojiList(tabs[i], widget.sendMessage));
    }

    _tabController = TabController(length: tabs.length, vsync: this);
  }
}



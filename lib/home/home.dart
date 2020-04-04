import 'dart:async';

import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/base/conf.dart';
import 'package:car_repair/entity/fire_user_info_entity.dart';
import 'package:car_repair/event/StartChatEvent.dart';
import 'package:car_repair/generated/json/fire_user_info_entity_helper.dart';
import 'package:car_repair/home/Conversation.dart';
import 'package:car_repair/home/MapPage.dart';
import 'package:car_repair/publish/MyNewPublishPage.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SquarePage.dart';
import 'drawer/MyDrawer.dart';

class HomePage extends StatelessWidget {


  final FirebaseUser user;

  const HomePage({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _HomePage(
      user: user,
    );
  }
}

class _HomePage extends StatefulWidget {
  final FirebaseUser user;

  const _HomePage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<_HomePage>
    with SingleTickerProviderStateMixin {
  final String mTitle = 'home';
  FireUserInfoEntity userInfo;
  static final String squareString = 'Funny mud pee';
  static final String chatString = 'Balabala';
  static final String mapString = 'Map';

  List<String> tabs = ['$squareString'];
  List<Widget> tabViews = [SquarePage()];
  TabController _tabController;
  StreamSubscription startChat;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    startChat =
        EventBus().on<StartChatEvent>().listen((event) => _startChat);
    if (userInfo == null) _refreshHomeState();
  }

  @override
  void dispose() {
    startChat?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: mTitle,
        home:Scaffold(
      appBar: _getAppBar(),
      body: _getBodyWidget(),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.publish),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyNewPublishPage()));
          }),
    ));
  }

  initTabs() {
    if (!(userInfo.chat != null && !userInfo.chat)) {
      tabs.add(squareString);
      tabViews.add(SquarePage());
    }
//    tabs = ['Funny mud pee'];
    if (userInfo.chat != null && userInfo.chat) {
      tabs.add(chatString);
      tabViews.add(ConversationPage());
    }
    if (userInfo.map != null && userInfo.map) {
      tabs.add(mapString);
      tabViews.add(MapPage());
    }
  }

  Widget _getAppBar() {
    if (tabs.length == 0) {
      initTabs();
    }

    if (tabs.length == 1) {
      return AppBar(
        title: Text('home'),
      );
    } else {
      return AppBar(
        title: Text('home'),
        bottom: TabBar(
            controller: _tabController,
            tabs: tabs.map((e) => Tab(text: e)).toList()),
      );
    }
  }

  Widget _getBodyWidget() {
    if (tabViews.length == 0) {
      initTabs();
    }
    if (tabs.length == 1) {
      return tabViews[0];
    } else {
      return TabBarView(
        controller: _tabController,
        children: tabViews.toList(),
      );
    }
  }

  _refreshHomeState() {
    FireStoreUtils.queryUserinfo(widget.user.uid).then((value) {
      setState(() {
        userInfo = fireUserInfoEntityFromJson(FireUserInfoEntity(),value.data);
        Config.userInfo = userInfo;
        tabs.clear();
        tabViews.clear();
        initTabs();

      });
    });
  }

  _startChat() {
    print('!!! start show chat in home.');
    if (userInfo != null && !(userInfo.chat ?? false)) {
      userInfo.chat = true;
      tabs.clear();
      tabViews.clear();
      initTabs();
      _tabController.animateTo(tabs.indexOf(chatString));
      FireStoreUtils.updateUserinfo(true, FireStoreUtils.CHAT, Config.user);
    } else {
      _tabController.animateTo(tabs.indexOf(chatString));
    }
  }
}
import 'dart:async';

import 'package:car_repair/base/Events.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/base/Config.dart';
import 'package:car_repair/entity/fire_user_info_entity.dart';
import 'package:car_repair/generated/json/fire_user_info_entity_helper.dart';
import 'package:car_repair/home/Conversation.dart';
import 'package:car_repair/home/FriendsPage.dart';
import 'package:car_repair/home/MapPage.dart';
import 'package:car_repair/publish/MyNewPublishPage.dart';
import 'package:car_repair/utils/UserInfoManager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SquarePage.dart';
import 'drawer/MyDrawer.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _HomePage(
      user: user,
    );
  }
}

class _HomePage extends StatefulWidget {
  final User user;

  const _HomePage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<_HomePage> with TickerProviderStateMixin {
  final String mTitle = 'home';
  FireUserInfoEntity userInfo;
  static final String squareString = 'Funny mud pee';
  static final String chatString = 'Balabala';
  static final String friendsString = 'bromance';
  static final String mapString = 'Map';

  List<String> tabs = [];
  List<Widget> tabViews = [];
  TabController _tabController;
  StreamSubscription startChat;
  StreamSubscription startFriends;

  @override
  void initState() {
    super.initState();
    userInfo = Config.userInfo;
    initTabs();
    _tabController = TabController(length: tabs.length, vsync: this);
    startChat = eventBus.on<StartChatEvent>().listen((event) => _startChat());
    startFriends =
        eventBus.on<FriendEvent>().listen((event) => _startFriends(event));
    if (userInfo == null) _refreshHomeState();
  }

  @override
  void dispose() {
    startChat?.cancel();
    startFriends?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: mTitle,
        home: Scaffold(
          appBar: _getAppBar(),
          body: _getBodyWidget(),
          drawer: MyDrawer(),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.publish),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyNewPublishPage()));
              }),
        ));
  }

  initTabs() {
    if (userInfo.square ?? true) {
      print('!!! add square');
      tabs.add(squareString);
      tabViews.add(SquarePage());
    }
//    tabs = ['Funny mud pee'];
    if ((userInfo.chat ?? false)) {
      print('!!! add chat');
      tabs.add(chatString);
      tabViews.add(ConversationPage());
    }
    if ((userInfo.friends ?? false)) {
      print('!!! add friends');
      tabs.add(friendsString);
      tabViews.add(FriendsPage());
    }
    if ((userInfo.map ?? false)) {
      print('!!! add map');
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
        userInfo =
            fireUserInfoEntityFromJson(FireUserInfoEntity(), value.data());
        Config.userInfo = userInfo;
        UserInfoManager.refreshSelf();
        tabs.clear();
        tabViews.clear();
        initTabs();
        _tabController = TabController(vsync: this, length: tabs.length);
      });
    });
  }

  _startChat() {
    print('!!! start show chat in home. ${userInfo.chat ?? false}');
    if (!tabs.contains(chatString)) {
      setState(() {
        userInfo.chat = true;
        tabs.clear();
        tabViews.clear();
        initTabs();
        var chatIndex = tabs.indexOf(chatString);
        print('!!! $chatIndex');
        _tabController = TabController(
            vsync: this,
            length: tabs.length,
            initialIndex: chatIndex >= 0 ? chatIndex : 0);
        FireStoreUtils.updateUserinfo(true, FireStoreUtils.CHAT, Config.user);
      });
    }
    // else {
    //   if (_tabController.index != tabs.indexOf(chatString))
    //     _tabController.animateTo(tabs.indexOf(chatString));
    // }
  }

  _startFriends(FriendEvent event) {
    print('!!! start show friend in home. ${userInfo.friends ?? false}');
    if (!tabs.contains(friendsString)) {
      setState(() {
        userInfo.friends = true;
        tabs.clear();
        tabViews.clear();
        initTabs();
        var friendsIndex = tabs.indexOf(friendsString);
        print('!!! $friendsIndex');
        _tabController = TabController(
            vsync: this,
            length: tabs.length,
            initialIndex: friendsIndex >= 0 ? friendsIndex : 0);
        FireStoreUtils.updateUserinfo(
            true, FireStoreUtils.FRIENDS, Config.user);
      });
    }
  }
}

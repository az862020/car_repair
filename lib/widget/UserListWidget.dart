import 'dart:async';

import 'package:car_repair/base/Events.dart';
import 'package:car_repair/entity/user_infor_entity.dart';
import 'package:car_repair/widget/AvatarWidget.dart';
import 'package:flutter/material.dart';

abstract class UserListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserListState();
  }

  Future<List<UserInforEntity>> getListData();

  Future<void> removeItem(UserInforEntity user);

  Future<void> UndoRemove(UserInforEntity user);
}

class UserListState extends State<UserListWidget> {
  List<UserInforEntity> dataList = List();
  StreamSubscription startFriends;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    startFriends = eventBus.on<FriendEvent>().listen((event) => _refreshData());
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
    startFriends?.cancel();
    dataList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        itemBuilder: _renderItem,
        itemCount: dataList.length == 0 ? 1 : dataList.length,
      ),
    );
  }

  void _getData({clear:false}){
    if (isLoading) return;
    isLoading = true;
    widget.getListData().then((list) {
      if(clear)dataList.clear();
      dataList.addAll(list);
      setState(() => isLoading = false);
    });
  }

  Future<void> _refreshData() async{
    print('!!! refreshData');
    _getData(clear: true);
  }

  Widget _renderItem(BuildContext context, int index) {
    if (dataList.length == 0) {
      return Container(
        height: 100.0,
        child: Center(
            child: Text(
          '你是一条龙! (You are a long.)',
          style: TextStyle(fontSize: 16.0),
        )),
      );
    }

    var item = dataList[index];

    return Dismissible(
      background: Container(color: Colors.red),
      key: Key(item.uid),
      onDismissed: (direction) {
        _remove(index, item, context);
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: AvatarWidget(item.uid, userInforEntity: item, click: true),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            height: 1.0,
            color: Colors.grey[300],
          )
        ],
      ),
    );
  }

  _remove(int index, UserInforEntity item, BuildContext context) {
    widget.removeItem(item).then((v) {
      setState(() {
        bool val = dataList.remove(item);
        print('!!! remove friend $val');
        if(!val) dataList.removeAt(index);
      });
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${item.displayName} removed"),
              IconButton(
                icon: Icon(Icons.autorenew),
                onPressed: () {
                  widget.UndoRemove(item).then((v) {
                      _refreshData();
                  }).catchError((e){
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('undo failed...')));
                  });
                },
              )
            ],
          )));
    }).catchError((e){
      print('!!! $e');
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Remove failed...')));
      setState(() {});
    });
  }
}

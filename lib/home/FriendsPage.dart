import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/user_infor_entity.dart';
import 'package:car_repair/utils/UserInfoManager.dart';
import 'package:car_repair/widget/UserListWidget.dart';
import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FriendsListState();
  }
}

class FriendsListState extends State<FriendsPage>
    with AutomaticKeepAliveClientMixin {
  List<UserInforEntity> friendsList = List();

  @override
  void initState() {
    super.initState();
    _getFriends();
    _refreshData();
  }

  _getFriends() {
    friendsList.clear();
    UserInfoManager.getFriendList().then((value) {
      setState(() {
        friendsList = value;
      });
    });
  }

  _refreshData(){
    UserInfoManager.RefreshShip().then((value) {
      if(true) _getFriends();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return FriendsList();
  }

}

class FriendsList extends UserListWidget{
  @override
  Future<bool> UndoRemove(UserInforEntity user) async{
    return _operator(user, true);
  }

  @override
  Future<List<UserInforEntity>> getListData() {
    return UserInfoManager.getFriendList();
  }

  @override
  Future<bool> removeItem(UserInforEntity user) {
    return _operator(user, false);
  }

  Future<bool> _operator(UserInforEntity user, bool isFriend) async{
    try {
      await UserInfoManager.operatiorUser(user, friend: isFriend);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

}

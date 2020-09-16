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

/// friends list just receiver , do not send event.
class FriendsList extends UserListWidget{

  @override
  Future<void>  UndoRemove(UserInforEntity user) {
    return _operator(user, true);
  }

  @override
  Future<List<UserInforEntity>> getListData() {
    return UserInfoManager.getFriendList();
  }

  @override
  Future<void> removeItem(UserInforEntity user) {
    return _operator(user, false);
  }

  Future<void> _operator(UserInforEntity user, bool isFriend) {
    return UserInfoManager.operatiorUser(user, friend: isFriend, event: false);
  }


}

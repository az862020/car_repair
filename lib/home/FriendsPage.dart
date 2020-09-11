import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/user_infor_entity.dart';
import 'package:car_repair/utils/UserInfoManager.dart';
import 'package:flutter/cupertino.dart';

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
    return ListView.builder(itemBuilder: null);
  }
}

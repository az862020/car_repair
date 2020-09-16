import 'package:car_repair/entity/user_infor_entity.dart';
import 'package:car_repair/utils/UserInfoManager.dart';
import 'package:car_repair/widget/UserListWidget.dart';
import 'package:flutter/material.dart';

class BlackListPage extends StatelessWidget {
  final String mTitle = 'MyBlackList';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: mTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(mTitle),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: BlackListWidget()
      ),
    );
  }
}

class BlackListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BlackListState();
  }
}

class BlackListState extends State<BlackListWidget>
    with AutomaticKeepAliveClientMixin {
  List<UserInforEntity> blackList = List();

  @override
  void initState() {
    super.initState();
    _getData();
    _refreshData();
  }

  _getData() {
    blackList.clear();
    UserInfoManager.getBlackList().then((value) {
      setState(() {
        blackList = value;
      });
    });
  }

  _refreshData(){
    UserInfoManager.RefreshShip().then((value) {
      if(true) _getData();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BlackListList();
  }

}

/// blacklist page just send event, do not receiver.
class BlackListList extends UserListWidget{

  BlackListList():super(isNotifyBlack:false);

  @override
  Future<void>  UndoRemove(UserInforEntity user) {
    return _operator(user, true);
  }

  @override
  Future<List<UserInforEntity>> getListData() {
    return UserInfoManager.getBlackList();
  }

  @override
  Future<void> removeItem(UserInforEntity user) {
    return _operator(user, false);
  }

  Future<void> _operator(UserInforEntity user, bool isBlack) {
    return UserInfoManager.operatiorUser(user, black: isBlack);
  }


}

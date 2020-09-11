
import 'package:car_repair/entity/user_infor_entity.dart';
import 'package:car_repair/widget/AvatarWidget.dart';
import 'package:flutter/material.dart';

abstract class UserListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserListState();
  }

  Future<List<UserInforEntity>> getListData();

  Future<bool> removeItem(UserInforEntity user);

  Future<bool> UndoRemove(UserInforEntity user);
}

class UserListState extends State<UserListWidget> {
  List<UserInforEntity> dataList = List();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
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

  void _getData() {
    widget.getListData().then((list) {
      setState(() {
        dataList.addAll(list);
      });
    });
  }

  Future<void> _refreshData() {
    dataList.clear();
    _getData();
  }

  Widget _renderItem(BuildContext context, int index) {
    var item = dataList[index];

    return Dismissible(
      background: Container(color: Colors.red),
      key: Key(item.uid),
      onDismissed: (direction) {
        _remove(item);
      },
      child: AvatarWidget(item.uid, userInforEntity: item, click: true),
    );
  }

  _remove(UserInforEntity item) {
    widget.removeItem(item).then((isOK) {
      if (isOK) {
        setState(() {
          dataList.remove(item);
        });
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${item.displayName} removed"),
                IconButton(
                  icon: Icon(Icons.autorenew),
                  onPressed: () {
                    widget.UndoRemove(item).then((isOK) {
                      if (isOK)
                        _refreshData();
                      else
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text('undo failed...')));
                    });
                  },
                )
              ],
            )));
      } else {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Remove failed...')));
        setState(() {});
      }
    });


  }
}

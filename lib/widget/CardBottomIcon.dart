import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/FireUserInfo.dart';
import 'package:car_repair/entity/Square.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardBottomIcon extends StatefulWidget {
  Square square;
  Function() likeClick;

  CardBottomIcon(this.square, this.likeClick);

  @override
  State<StatefulWidget> createState() {
    return _CardBottomIcon();
  }
}

class _CardBottomIcon extends State<CardBottomIcon> {
  FireUserInfo creater;

  @override
  Widget build(BuildContext context) {
    var square = widget.square;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 5.0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage:
                                    creater == null || creater.photoUrl == null
                                        ? AssetImage(
                                            'assets/images/account_box.png')
                                        : CloudImageProvider(creater.photoUrl),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  creater == null ? '' : creater.displayName,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              _createButtonIcon(
                                  Icons.remove_red_eye, '${square.click}'),
                              _createButtonIcon(Icons.comment, '0'),
                              GestureDetector(
                                child: _createButtonIcon(
                                    Icons.thumb_up, '${square.favorate}'),
                                onTap: () {
                                  widget.likeClick();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Offstage(
                        offstage: square.note.isEmpty,
                        child: Text('${square.note}'),
                      ),
                    ],
                  )),
            )
          ],
        ));
  }

  Widget _createButtonIcon(IconData icon, String text) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 5),
          child: Icon(
            icon,
            color: Colors.grey,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            text,
            style: TextStyle(color: Colors.grey),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    FireStoreUtils.queryUserinfo(widget.square.userID).then((snapshot) {
      setState(() {
        FireUserInfo userInfo = FireUserInfo.fromJson(snapshot.data);
        userInfo.uid = snapshot.documentID;
        creater = userInfo;
      });
    });
  }
}

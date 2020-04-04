import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/Square.dart';
import 'package:car_repair/entity/fire_user_info_entity.dart';
import 'package:car_repair/generated/json/fire_user_info_entity_helper.dart';
import 'package:car_repair/home/ChatPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardBottomIcon extends StatefulWidget {
  Square square;
  DocumentReference squareReference;

  CardBottomIcon(this.square, this.squareReference);

  @override
  State<StatefulWidget> createState() {
    return _CardBottomIcon();
  }
}

class _CardBottomIcon extends State<CardBottomIcon> {
  FireUserInfoEntity creater;

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
                          GestureDetector(
                            child: Row(
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
                            onTap: (){
                              FireStoreUtils.getConversation(creater.uid).then((entity) {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => ChatPage(entity, creater.displayName??'')));
                              });
                            },
                          ),
                          Row(
                            children: <Widget>[
                              _createButtonIcon(
                                  Icons.remove_red_eye, '${square.click}'),
                              _createButtonIcon(Icons.comment, '${square.comment}'),
                              GestureDetector(
                                child: _createButtonIcon(
                                    Icons.thumb_up, '${square.favorate}',
                                    colors:
                                        isFavorate ? Colors.blue : Colors.grey),
                                onTap: () {
                                  _toggleFavorate();
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

  Widget _createButtonIcon(IconData icon, String text, {Color colors}) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 5),
          child: Icon(
            icon,
            color: colors ?? Colors.grey,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            text,
            style: TextStyle(color: colors ?? Colors.grey),
          ),
        )
      ],
    );
  }

  DocumentReference reference;
  Map<String, dynamic> dataMap;
  bool isFavorate = false;
  bool isCommiting = false;

  @override
  void initState() {
    super.initState();
    FireStoreUtils.queryUserinfo(widget.square.userID).then((snapshot) {
      setState(() {
        FireUserInfoEntity userInfo = fireUserInfoEntityFromJson(FireUserInfoEntity(), snapshot.data);
        userInfo.uid = snapshot.documentID;
        creater = userInfo;

        snapshot.data.containsKey('123');
      });
    });
    _getFavorateState();
  }

  _getFavorateState() {
    reference = FireStoreUtils.getMyFavoratedList();
    reference.get().then((value) {
      if (value.data == null) {
        dataMap = Map();
      } else {
        dataMap = value.data;
      }
      setState(() {
        isFavorate = FireStoreUtils.isSquareFavorate(dataMap, widget.square.id);
      });
    });
  }

  void _toggleFavorate() {
    if (reference != null && dataMap != null && !isCommiting) {
      isCommiting = true;
      FireStoreUtils.toggleFavorate(widget.squareReference, widget.square.id,
              reference, dataMap, isFavorate)
          .then((Null) {
        setState(() {
          isFavorate = !isFavorate;
          isCommiting = false;
          widget.square.favorate += isFavorate ? 1 : -1;
          if (isFavorate !=
              FireStoreUtils.isSquareFavorate(dataMap, widget.square.id)) {
            print('!!!  data is different, need refresh.');
            _getFavorateState();
          }

        });
      }).catchError((e) {
        isCommiting = false;
        print('!!! error');
      });
    }
  }
}

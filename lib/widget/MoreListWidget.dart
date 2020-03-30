import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/Square.dart';
import 'package:car_repair/publish/SquareDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BottomMore.dart';
import 'SquareCard.dart';

abstract class MoreListWidget extends State {

  int commentStep = 20;
  bool isSend = false;
  bool isLoading = false;
  bool isEnd = false;
  List<DocumentSnapshot> dataList = List();
  ScrollController _scrollController = ScrollController();

  Map<String, dynamic> lists;

  DocumentReference getListMap();

  @override
  void initState() {
    super.initState();
    getListMap().get().then((value){
      lists = value.data;
      if (lists == null) {
        lists = Map();
      }
      _getData();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    lists = null;
    dataList.clear();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 1080,
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          itemBuilder: _renderItem,
          itemCount:
          dataList.length == 0 ? 1 : dataList.length + (isEnd ? 1 : 2),
          controller: _scrollController,
        ),
      ),
    );
  }


  Widget _renderItem(BuildContext context, int index) {
    if (index < dataList.length ) {
      return _buildListItem(context: context, index: index);
    }
    return Offstage(
      offstage: isEnd,
      child: BottomMore.getMoreWidget(),
    );
  }

  Widget _buildListItem({BuildContext context, int index}) {
    var data = dataList[index];
    final square = Square.fromJson(data.data);
    square.id = data.documentID;

    return Padding(
      key: ValueKey(square.id),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: SquareCard(square, (square) {
        square.click += 1;
        Navigator.push(context, MaterialPageRoute(builder: (context) => SquareDetails(square, data.reference)));
        data.reference.updateData({'click': FieldValue.increment(1)});
      }),
    );
  }

  Future _getData() async{
    if (isLoading || lists == null || isEnd) return;
    isLoading = true;

    var query = await FireStoreUtils.getMyDataByList(lists);
    List<DocumentSnapshot> list = query;
    print('!!! documents size ${list.length}');
    setState(() {
      isLoading = false;
//      if (list.length < commentStep) {
//        isEnd = true;
//      }
        isEnd = true;
      dataList.addAll(list);
    });
  }

  Future<Null> _refreshData() async{
    lists = null;
    dataList.clear();
    isLoading = false;
    isEnd = false;
    _getData();
  }
}
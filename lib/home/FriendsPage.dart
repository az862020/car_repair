
import 'package:flutter/cupertino.dart';

class FriendsPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {

  }

}

class FriendsListState extends State<FriendsPage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(itemBuilder: null);
  }



}
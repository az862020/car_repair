import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widget/MyDrawer.dart';


class HomePage extends StatelessWidget{
  final String mTitle = 'home';

  final FirebaseUser user;

  const HomePage({Key key, @required this.user}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: mTitle,
      home: Scaffold(
        appBar: AppBar(title: Text(mTitle),),
        body: Column(
          children: <Widget>[
            Text('ddddddd \n $user'),
          ],
        ),
        drawer: MyDrawer(user),
      ),
    );
  }

}

class HomeState extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return null;
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:car_repair/base/Config.dart';
import 'package:car_repair/widget/MySwitch.dart';

class MySettingsPage extends StatelessWidget{
  final String mTitle = 'MySettings';
  final FirebaseUser _user;

  MySettingsPage(this._user);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: mTitle,
      home: Scaffold(
        appBar: AppBar(title: Text('$mTitle'),),
        body: MySettings(_user),
      ),
    );
  }

}

class MySettings extends StatefulWidget {
  final FirebaseUser _user;

  MySettings(this._user);

  @override
  State<StatefulWidget> createState() {
    return _MySettingsState();
  }
}

class _MySettingsState extends State<MySettings> {

  @override
  Widget build(BuildContext context) {
    return ListView(

      children: <Widget>[
        MySwitchView(Config.testSettings, Config.testSettings),
        MySwitchView(Config.testSettings2, Config.testSettings2),
      ],
    );
  }
}
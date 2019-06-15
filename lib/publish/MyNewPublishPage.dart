import 'package:flutter/material.dart';

class MyNewPublishPage extends StatelessWidget {
  final String mTitle = 'MyNewPublishPage';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: mTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(mTitle),
        ),
        body: MyNewPublish(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.publish), onPressed: () => publish()),
      ),
    );
  }
}

publish() {}

class MyNewPublish extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyNewPublishState();
  }
}

var titleControl = TextEditingController();
var describeControl = TextEditingController();

class _MyNewPublishState extends State<MyNewPublish> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: titleControl,
          decoration:
              InputDecoration(hintText: "This is title. Empty is allow."),
        ),
        Container(
          color: Colors.grey,
          child: IconButton(icon: Icon(Icons.add), onPressed: () => add()),
        ),
        TextFormField(
          controller: titleControl,
          decoration:
              InputDecoration(hintText: "This is describe. Empty is allow."),
        ),
      ],
    );
  }

  add() {}
}

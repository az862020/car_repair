import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/conversation_entity.dart';
import 'package:car_repair/generated/json/conversation_entity_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ConversationCard.dart';

class ConversationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConversationPageState();
  }
}

class _ConversationPageState extends State<ConversationPage> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FireStoreUtils.getConversationList(),
//      stream: FireStoreUtils.querySquareByUser('${Config.user.uid}', 'default'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return LinearProgressIndicator();
        if (snapshot.connectionState == ConnectionState.none)
          return Center(
              child: Text(
            'No data!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ));
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    print('!!! conversation size ${snapshot.length}');
    return ListView.builder(
        itemCount: snapshot.length,
        itemBuilder: (context, i) {
          if (i > snapshot.length || snapshot.length == 0) return null;
//          if (i == snapshot.length) return BottomMore.getMoreWidget(isEnd);
          DocumentSnapshot doc = snapshot[i];
          ConversationEntity entity = conversationEntityFromJson(
              ConversationEntity(), doc.data);
          entity.id = doc.documentID;
          return ConversationCard(entity);
        });

  }

}

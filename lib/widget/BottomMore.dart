import 'package:flutter/material.dart';

class BottomMore {
  static Widget getMoreWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'loading...   ',
              style: TextStyle(fontSize: 16.0),
            ),

            CircularProgressIndicator(
              strokeWidth: 3.0,
            )
          ],
        ),
      ),
    );
  }
}

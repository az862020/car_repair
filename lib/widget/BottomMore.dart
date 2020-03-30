import 'package:flutter/material.dart';

class BottomMore {
  static Widget getMoreWidget(bool isEnd) {
    return Offstage(
        offstage: isEnd,
        child: Center(
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
        ));
  }
}

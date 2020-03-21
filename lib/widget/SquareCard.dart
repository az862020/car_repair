import 'dart:ui';

import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/entity/Square.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SquareCard extends StatefulWidget {
  Square square;

  SquareCard(this.square);

  @override
  State<StatefulWidget> createState() {
    return _SquareCard(square);
  }
}

class _SquareCard extends State<SquareCard> {
  Square square;

  _SquareCard(this.square);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: FractionalOffset(0.5, 1.0),
            children: <Widget>[
              Image(
                image: CloudImageProvider(square.pics[0]),
                fit: BoxFit.cover,
                height: 200,
                width: 600,
              ),
              Container(
                color: Color(0x66000000),
                height: 32,
                width: 600,
              ),
              Text(
                square.title,
                style: TextStyle(
                    fontSize: 28.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _createButtonIcon(Icons.remove_red_eye, '${square.click}'),
                Row(
                  children: <Widget>[
                    _createButtonIcon(Icons.comment, '0'),
                    _createButtonIcon(Icons.thumb_up, '${square.favorate}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
}

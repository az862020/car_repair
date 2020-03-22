import 'package:car_repair/base/CloudImageCache.dart';
import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/entity/Square.dart';
import 'package:flutter/material.dart';

class SquareDetails extends StatelessWidget {
  final String mTitle = 'SquareDetails';

  Square square;

  SquareDetails(this.square);

  @override
  Widget build(BuildContext context1) {
    return MaterialApp(
      title: mTitle,
      home: Scaffold(
//        appBar: AppBar(
//          title: Text(mTitle),
//          leading: IconButton(
//              icon: Icon(Icons.arrow_back),
//              onPressed: () => Navigator.pop(context)),
//        ),
//        body: SquareDetailsPage(square),
        body: NestedScrollView(
          headerSliverBuilder: (context, isS) {
            return <Widget>[
              SliverAppBar(
                  primary: true,
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context1)),
                  expandedHeight: 300.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    //可以展开区域，通常是一个FlexibleSpaceBar
                    centerTitle: true,
                    title: Text(mTitle),
                    background: Hero(
                        tag: '${square.pics[0]}',
                        child: Image(
                            image: CloudImageProvider(square.pics[0]),
                            fit: BoxFit.cover)),
                  )),
            ];
          },
          body: SquareDetailsPage(square),
        ),
      ),
    );
  }
}

class SquareDetailsPage extends StatefulWidget {
  Square square;

  SquareDetailsPage(this.square);

  @override
  State<StatefulWidget> createState() {
    return _SquareDetailsPage(square);
  }
}

class _SquareDetailsPage extends State<SquareDetailsPage> {
  Square square;

  _SquareDetailsPage(this.square);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '${square.pics[0]}',
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  @override
  void initState() {}
}

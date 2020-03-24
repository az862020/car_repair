import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/entity/Square.dart';
import 'package:car_repair/publish/PhotoGallery.dart';
import 'package:flutter/material.dart';

import 'GalleryPhotoViewWrapper.dart';

int photoIndex = 0;

class SquareDetails extends StatelessWidget {
  Square square;

  SquareDetails(this.square);

  @override
  Widget build(BuildContext context1) {
    return MaterialApp(
      title: square.title,
      home: Scaffold(
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
                    title: Text(square.title),
                    background: Hero(
                        tag: '${square.id}',
                        child: GestureDetector(
                          child: PageView.builder(
                            itemCount: square.pics.length,
                            onPageChanged: (i) => photoIndex = i,
                            controller: PageController(initialPage: photoIndex),
                            itemBuilder: (context, index) => Image(
                                image: CloudImageProvider(square.pics[index]),
                                fit: BoxFit.cover),
                          ),
                          onTap: () {
                            preview(context1, square);
                          },
                        )),
                  )),
            ];
          },
          body: SquareDetailsPage(square),
        ),
      ),
    );
  }
}

preview(BuildContext context, Square square) {
  //todo open gallery or play video.
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => GalleryPhotoViewWrapper(
        photos: square,
        initialIndex: photoIndex,
      ),
    ),
  );
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
  void dispose() {
    super.dispose();
    photoIndex = 0;
  }


}

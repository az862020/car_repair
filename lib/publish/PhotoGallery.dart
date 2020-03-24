import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/entity/Square.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

int photoIndex = 0;
List<String> photos;
BuildContext context;


class PhotoGallery extends StatelessWidget {
  /**
   * 不用了. 有手势冲突.
   */
  PhotoGallery({List<String> photo, int index}) {
    photoIndex = index;
    photos = photo;
  }

  @override
  Widget build(BuildContext context1) {
    context = context1;
    return MaterialApp(
      title: 'Gallery',
      home: Scaffold(
        body: PhotoGalleryPager(),
      ),
    );
  }
}

class PhotoGalleryPager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PhotoGallery();
  }
}

class _PhotoGallery extends State<PhotoGalleryPager> {
  @override
  Widget build(BuildContext context2) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          child:
          PageView.builder(
            itemCount: photos.length,
            itemBuilder: (context, index) =>
                PhotoView(imageProvider: CloudImageProvider(photos[index])),
            dragStartBehavior: DragStartBehavior.down,
            controller: PageController(initialPage: photoIndex),
          ),
//          onVerticalDragEnd: (down) {
//            print('!!!  drag  down ${down.velocity}');
//            print('!!!  drag  down ${down.primaryVelocity}');
//          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        )
      ],
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';

import 'base/conf.dart';
import 'login/LoginPage.dart';

void main() async {
  runApp(LoginPage());
//  FirebaseAuth.fromApp(app)
  Config().initAppDir();

  //FireBase Storage need initialized

  Config().initFirebaseStorage();
}

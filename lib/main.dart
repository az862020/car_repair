import 'package:flutter/material.dart';

import 'base/conf.dart';
import 'login/LoginPage.dart';

void main() async {
  runApp(LoginPage());
//  FirebaseAuth.fromApp(app)
  Config().initAppDir();

  //FireBase Storage need initialized

  Config().initFirebaseStorage();
}

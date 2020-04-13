import 'package:flutter/material.dart';

import 'base/conf.dart';
import 'Account/LoginPage.dart';

void main() async {
  runApp(LoginPage());
//  FirebaseAuth.fromApp(app)
  Config().initAppDir();

  //FireBase Storage need initialized

  Config().initFirebaseStorage();
}

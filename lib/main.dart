import 'package:flutter/material.dart';

import 'base/Config.dart';
import 'Account/LoginPage.dart';

void main() async {
  runApp(LoginPage());
  Config().initAppDir();

}

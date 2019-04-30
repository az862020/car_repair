import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegisterPage extends StatelessWidget{
  final String mTitle = 'Register';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: mTitle,
      home: Scaffold(
        appBar: AppBar(title: Text(mTitle),),
        body: RegisterState(),
      ),
    );
  }

}

class RegisterState extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }

}

class _RegisterState extends State<RegisterState> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordAgainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: usernameController,
              validator: (string) {
                if (string.isEmpty) return 'email can\'t be empty.';
                if (!isEmail(string)) return 'this is not a Email address.';

              },
              decoration: InputDecoration(
                  labelText: 'Enter your Email address',
                  hintText: 'Just can be Email',
                  icon: Icon(Icons.account_box)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (string) {
                  if (string.isEmpty) return 'Password can\'t be empty.';
                  if (string.length < 6 || string.length > 15) return 'Password should be 6 - 15.';
                },
                decoration: InputDecoration(
                    labelText: 'Enter your password',
                    hintText: 'Just can not be empty',
                    icon: Icon(Icons.lock)),
              ),
            ),
            TextFormField(
              controller: passwordAgainController,
              validator: (string) {
                if (string.isEmpty) return 'Password can\'t be empty.';
                if (string.length < 6 || string.length > 15) return 'Password should be 6 - 15.';
                if (string != passwordController.text) return 'Password is different.';
              },
              decoration: InputDecoration(
                  labelText: 'Enter your username',
                  hintText: 'Just can not be empty',
                  icon: Icon(Icons.account_box)),
            ),

            Container(
              height: 1.0,
            ),

            RaisedButton(
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue[700],
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  RegisterPage();
                }));
              },
            ),

          ],
        ),
      ),
    );;
  }

  static bool isEmail(String str) {
    return new RegExp('^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+\$').hasMatch(str);
  }
}
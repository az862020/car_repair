import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/base/Config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatelessWidget {
  final String mTitle = 'Register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mTitle),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: RegisterState(),
    );
  }
}

class RegisterState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<RegisterState> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordAgainController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    passwordAgainController.dispose();
    super.dispose();
  }

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
                return null;
              },
              decoration: InputDecoration(
                  labelText: 'Enter your Email address',
                  hintText: 'Just can be Email',
                  icon: Icon(Icons.account_box)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (string) {
                  if (string.isEmpty) return 'Password can\'t be empty.';
                  if (string.length < 6 || string.length > 15)
                    return 'Password should be 6 - 15.';
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Enter your password',
                    hintText: 'Just can not be empty',
                    icon: Icon(Icons.lock)),
              ),
            ),
            TextFormField(
              controller: passwordAgainController,
              obscureText: true,
              validator: (string) {
                if (string.isEmpty) return 'Password can\'t be empty.';
                if (string.length < 6 || string.length > 15)
                  return 'Password should be 6 - 15.';
                if (string != passwordController.text)
                  return 'Password is different.';
                return null;
              },
              decoration: InputDecoration(
                  labelText: 'Enter your password again',
                  hintText: 'Just can not be empty',
                  icon: Icon(Icons.lock)),
            ),
            Container(
              height: 15.0,
            ),
            RaisedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Offstage(
                      offstage: !isLoading,
                      child: SizedBox(
                        width: 16.0,
                        height: 16.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          strokeWidth: 2.0,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              color: Colors.blue[700],
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  register(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  static bool isEmail(String str) {
    return new RegExp('^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+\$')
        .hasMatch(str);
  }

  //注册
  register(BuildContext context) {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      registerByFirebase().then((user) {
        setState(() {
          addItem(user);
          isLoading = false;
          print(user);
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Register finish! ${user.email}')));
          Navigator.pop(context, user);
        });
      }).catchError((e) {
        setState(() {
          isLoading = false;
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Register failed! $e')));
        });
      });
    } else {
//      Scaffold.of(context).showSnackBar(SnackBar(content: Text('')));
    }
  }

  //firebase的注册
  Future<User> registerByFirebase() async {
    var result = FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: usernameController.text,
      password: passwordController.text,
    );
    result.catchError((e) {
      print('!!!${e.toString()}');
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Register failed! $e')));
    });
    var user = (await result).user;
    Config.user = user;
    return user;
  }

  void addItem(User user) {
//    Firestore.instance
//        .collection('userinfo')
////        .add({'favorate': new List(), 'displayName': user.email, 'photoUrl': user.photoUrl,'publish':new List()});
//        .document(user.uid)
//        .setData({'displayName': user.email, 'photoUrl': user.photoUrl});
    FireStoreUtils.addUserinfo(user);
  }
}

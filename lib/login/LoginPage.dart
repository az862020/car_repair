import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:car_repair/home.dart';
import 'package:car_repair/register/RegisterPage.dart';

final String RemberSet = 'rember';
final String UsernameSet = 'rember_username';
final String PasswordSet = 'rember_password';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mTitle = 'Login';

    return MaterialApp(
      title: mTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(mTitle),
        ),
        body: LoginPageForm(),
      ),
    );
  }
}

class LoginPageForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageFormState();
  }
}

class _LoginPageFormState extends State<LoginPageForm> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool rember = false;
  String username = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    getRemberSet();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
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
                if (string.isEmpty) return 'Username can\'t be empty.';
              },
              decoration: InputDecoration(
                  labelText: 'Enter your username',
                  hintText: 'Just can not be empty',
                  icon: Icon(Icons.account_box)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (string) {
                  if (string.isEmpty) return 'Password can\'t be empty.';
                },
                decoration: InputDecoration(
                    labelText: 'Enter your password',
                    hintText: 'Just can not be empty',
                    icon: Icon(Icons.lock)),
              ),
            ),
            Container(
              height: 1.0,
            ),
            CheckboxListTile(
              title: Text('Rember your account.'),
              value: rember,
              onChanged: (check) {
                setState(() {
                  rember = check;
                });
              },
            ),
            Container(
              height: 1.0,
            ),
            RaisedButton(
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
//                    crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Offstage(
                      offstage: !isLoading,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                            strokeWidth: 2.0,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                //如果验证通过
                if (_formKey.currentState.validate()) {
                  if (!isLoading) {
                    falseHttp();
                  } else {
//                    Scaffold.of(context).showSnackBar(SnackBar(
//                      content: Text(' you are loading, plz wait.'),
//                    ));
                    print('catch click event when loging... ');
                  }
                }
              },
              color: Colors.blue[400],
            ),
            RaisedButton(
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue[700],
              onPressed: () {
                gotoRegister(context);
              },
            ),
            GestureDetector(
              onTap: () {
                print('tap');
                loginGoogle().then((user) {
                  gotoHome(user, context);
                }).catchError((e) {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Login failed! $e')));
                });
              },
              child: Image.asset(
                'assets/images/signin_google.png',
                height: 40.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //开启定时器,模拟HTTP请求.
  void falseHttp() {
    setState(() {
      isLoading = true;
      print('tap');
    });
    login().then((user) {
      //when success.
      print(user);
      setState(() {
        isLoading = false;
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Logined!')));
        setRemberSet();

        gotoHome(user, context);
      });
    }).catchError((e) {
      print('!!! $e');
      //when failed.
      setState(() {
        isLoading = false;
        if (e ==
            'ERROR NETWORK REQUEST FAILED, A network error (such as timeout, interrupted connection or unreachable host') {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Login failed! Google Service is not running. Run Google Play Store first and try again.')));
        } else {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Login failed! $e')));
        }
      });
    });
  }

  Future<FirebaseUser> login() async {
    final AuthCredential credential = EmailAuthProvider.getCredential(
        email: usernameController.text, password: passwordController.text);

    final FirebaseUser user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print('signed in ' + user.email);
    return user;
  }

  Future<FirebaseUser> loginGoogle() async {
//    Dialog();
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    final FirebaseUser user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print('signed in ' + user.displayName);
    print(user);
    return user;
  }

  //跳转注册界面,并且还会接收注册成功后新创建的user.
  gotoRegister(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) =>RegisterPage()))
        .then((user) {
      if (user != null) {
        print('!!! get user in loginpage  $user');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomePage(user: user);
        }));
      }
    });
  }

  //登录成功,获取到了用户信息,携带user跳转home.
  gotoHome(FirebaseUser user, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage(user: user);
    }));
  }

  //获取是否记住账号密码.
  void getRemberSet() async {
    final sharedPreferences = await SharedPreferences.getInstance();
      final remberV = (sharedPreferences.getBool(RemberSet) ?? false);
        username = (sharedPreferences.getString(UsernameSet) ?? '');
        password = (sharedPreferences.getString(PasswordSet) ?? '');
    setState(() {
      rember = remberV;
      print('!!!!! rember $rember');
      if (rember) {
        usernameController.text = username;
        passwordController.text = password;
        print('!!!!  username:$username  password:$password');
      }
    });
  }

  //登录成功之后,保存
  void setRemberSet() async {
    final sp = await SharedPreferences.getInstance();
    sp.setBool(RemberSet, rember);
    if (rember) {
      sp.setString(UsernameSet, usernameController.text);
      sp.setString(PasswordSet, passwordController.text);
    }
  }
}

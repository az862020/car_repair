import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
 * 封装设置里面的开关.传入一个配置文件里面的key值.代表这是哪项配置.
 * 要实现读取当前值,修改当前值会自动存储.
 * (可以看下,是否要区别账号.)
 */
class MySwitchView extends StatefulWidget{
  String settingsKey;
  String title;

  MySwitchView(this.settingsKey, this.title);

  @override
  State<StatefulWidget> createState() {
    return _SwitchViewState();
  }

}

class _SwitchViewState extends State<MySwitchView> {
  bool isCheck = false;

  @override
  void initState() {
    super.initState();
    loadSetting();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left:18.0, right: 18.0),
      height: 48.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Expanded(child: new Text(widget.title)),
          new Container(  //嵌套一个Container使点击Switch时也会改变其状态
            child: new Switch(
              value: isCheck,
              onChanged: (b) {
                setState(() {
                  isCheck = b;
                  saveSetting();
                  doSomethings();
                });
//                widget.onChanged(b);
              },
            ),
          ),
        ],
      ),
    );
  }



  loadSetting() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      isCheck = sp.getBool(widget.settingsKey) ?? false;
    });
  }

  saveSetting() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sp.setBool(widget.settingsKey, isCheck);
    });
  }

  doSomethings() {
    //TODO switch case by input string to do things.
    print('${widget.settingsKey} balabala.');

  }

}
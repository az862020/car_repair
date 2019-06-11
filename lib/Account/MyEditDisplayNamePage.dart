import 'package:car_repair/base/conf.dart';
import 'package:car_repair/utils/FireBaseUtils.dart';
import 'package:flutter/material.dart';

class MyEditDisplayNamePage extends StatelessWidget {
  final String mTitle = 'EditDisplay';

  @override
  Widget build(BuildContext context) {
//    return EditDisplayNamePage(mTitle);
    return Scaffold(
      appBar: AppBar(
        title: Text(mTitle),
      ),
      body: EditDisplayNamePage(mTitle),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.cloud_done),
          onPressed: () => updateDisPlayName(context)),
    );
  }
}

updateDisPlayName(BuildContext context) {
  if (_formKey.currentState.validate()) {
    FireBaseUtils.updateUserInfo(
        displayNameControler.text, FireBaseUtils.DISPLAYName,
        dialogContext: context);
  }
}

final _formKey = GlobalKey<FormState>();
final displayNameControler = TextEditingController();

class EditDisplayNamePage extends StatefulWidget {
  final String mTitle;

  EditDisplayNamePage(this.mTitle);

  @override
  State<StatefulWidget> createState() {
    return _EditDisplayName();
  }
}

class _EditDisplayName extends State<EditDisplayNamePage> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: TextFormField(
          autofocus: true,
          controller: displayNameControler,
          validator: (string) {
            if (string.isEmpty) return 'displayName can\'t be empty.';
          },
          decoration: InputDecoration(
              labelText: 'Enter your displayName',
              hintText: 'Just can not be empty',
              icon: Icon(Icons.insert_emoticon)),
        ));
  }

  @override
  void initState() {
    super.initState();
    if (Config.user.displayName != null)
      displayNameControler.text = Config.user.displayName;
  }
}

import 'package:flutter/cupertino.dart';

class ValidationDialog extends StatelessWidget {
  final String message;

  const ValidationDialog({Key key, this.message}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Error'),
      content: Text(message),
      actions: <Widget>[
        CupertinoButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'))
      ],
    );
  }

}
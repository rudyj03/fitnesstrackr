import 'package:fitnesstrackr/model/name.dart';
import 'package:flutter/cupertino.dart';
import '../../styles.dart';

class NameRow extends StatelessWidget {
  final Name selectedName;


  const NameRow({Key key, this.selectedName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  CupertinoIcons.person_solid,
                  color: CupertinoColors.systemBlue,
                  size: 28,
                ),
                SizedBox(width: 6),
                Text(
                  'Who?',
                  style: Styles.fieldLabel,
                ),
                SizedBox(width: 25),
                Text(
                  selectedName.name,
                  style: Styles.selectedValue,
                ),
              ],
            ),
          ]
        ),
      ]
    ); 
  }
}
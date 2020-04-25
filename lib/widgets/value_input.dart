import 'package:fitnesstrackr/model/workout.dart';
import 'package:flutter/cupertino.dart';
import '../styles.dart';

class ValueInput extends StatelessWidget {
  final Workout selectedWorkout;
  final Function onChange;

  const ValueInput({Key key, this.selectedWorkout, this.onChange}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var unitsText = selectedWorkout.units == "" ? "" : ' ( in ' + selectedWorkout.units + ' )';
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  CupertinoIcons.clock_solid,
                  color: CupertinoColors.systemBlue,
                  size: 28,
                ),
                SizedBox(width: 6),
                Text(
                  'How much?' + unitsText,
                  style: Styles.fieldLabel,
                ),
              ],
            ),
          ],
        ),
        Container(height: 50,
          child: CupertinoTextField(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            clearButtonMode: OverlayVisibilityMode.editing,
            textCapitalization: TextCapitalization.words,
            style: Styles.valueInput,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0,
                  color: CupertinoColors.inactiveGray,
                ),
              ),
            ),
            onChanged: (val) => onChange(val), 
          ),
        )
      ],
    );
  }

}
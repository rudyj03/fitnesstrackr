import 'package:fitnesstrackr/model/workout.dart';
import 'package:flutter/cupertino.dart';
import '../styles.dart';

class WorkoutRow extends StatelessWidget {
  final Workout selectedWorkout;


  const WorkoutRow({Key key, this.selectedWorkout})
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
                  CupertinoIcons.heart_solid,
                  color: CupertinoColors.systemBlue,
                  size: 28,
                ),
                SizedBox(width: 6),
                Text(
                  'What?',
                  style: Styles.fieldLabel,
                ),
                SizedBox(width: 25),
                Text(
                  selectedWorkout.name,
                  style: Styles.selectedValue,
                ),
              ],
            ),
          ],
        )
      ]
    );
  }
}
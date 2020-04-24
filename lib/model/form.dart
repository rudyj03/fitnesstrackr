import 'package:fitnesstrackr/model/name.dart';
import 'package:fitnesstrackr/model/workout.dart';

class WorkoutForm {
  Name name;
  Workout workout;
  double duration;

  WorkoutForm();

  // Method to make GET parameters.
  String toParams(){
    var cell = workout.index + name.index.toString();
    return "?type=update&cell=$cell&value=$duration";
  }
}
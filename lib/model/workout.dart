class Workout {
  String workout;
  String units;
  String index;

  Workout();

  Workout.fromJSON(Map<String, dynamic> json) : 
        workout = json['workout'],
        units = json['units'],
        index = json['index'];
}
class Workout {
  String name = "";
  String units = "";
  String index = "";

  Workout();

  Workout.fromJSON(Map<String, dynamic> json) : 
        name = json['workout'],
        units = json['units'],
        index = json['index'];

}
class PlayerWorkout {
  String name = "";
  List<WorkoutInfo> workoutInfo = List<WorkoutInfo>();
  double totalScore = 0.0;

  PlayerWorkout();

  PlayerWorkout.fromJSON(Map<String, dynamic> json) {
    this.name = json['name'];
    List.from(json['workoutInfo']).forEach((item){
      workoutInfo.add(WorkoutInfo(item["workout"], item["amount"].toDouble(), item["units"]));
    });
    this.totalScore = json['totalScore'].toDouble();
  } 
        
}

class WorkoutInfo {
  String workout = "";
  double amount = 0.0;
  String units = "";

  WorkoutInfo(String workout, double amount, String units){
    this.workout = workout;
    this.amount = amount;
    this.units = units;
  }
  
}
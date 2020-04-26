import 'dart:convert' as convert;
import 'package:fitnesstrackr/model/leadboard_entry.dart';
import 'package:fitnesstrackr/model/name.dart';
import 'package:fitnesstrackr/model/workout.dart';
import 'package:http/http.dart' as http;
import '../model/form.dart';

/// FormController is a class which does work of saving FeedbackForm in Google Sheets using 
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class FormController {

  // Google App Script Web URL.
  //working with week 2's sheet (latest API)
  static const String URL = "https://script.google.com/macros/s/AKfycbypIrYS8IVKtRvp68_IBI_a0WRsOwXpIYob16H2SoexGvltRcw/exec";

  //Dev script url
  //static const String URL = "https://script.google.com/macros/s/AKfycbz17K1s6VN4488TBMycrJSHHOPpRdDghlzqPowFLbM/dev";
  
  // Success Status Message
  static const STATUS_SUCCESS = "SUCCESS";

  // Default Contructor
  FormController();


  Future<http.Response> getNames() async {
    var response = await http.get(URL + "?type=getNames");
    return response;
  }

  List<Name> convertNamesFromJson(String json) {
    return (convert.jsonDecode(json)['names'] as List).map((i) => Name.fromJSON(i)).toList();
  }

  Future<http.Response> getWorkouts() async {
    var response = await http.get(URL + "?type=getWorkouts");
    return response;    
  }

  List<Workout> convertWorkoutsFromJson(String json) {
    return (convert.jsonDecode(json)['workouts'] as List).map((i) => Workout.fromJSON(i)).toList();
  }

  Future<http.Response> getLeaderboard() async {
    var response = await http.get(URL + "?type=getLeaderboard");
    return response;    
  }

  List<LeaderboardEntry> convertLeaderboardFromJson(String json) {
    return (convert.jsonDecode(json)['leaderboard'] as List).map((i) => LeaderboardEntry.fromJSON(i)).toList();
  }

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  Future<http.Response> submitForm(WorkoutForm feedbackForm) async {
    print("Submitting to " + URL+feedbackForm.toParams());
    var submitResponse = await http.get(URL + feedbackForm.toParams());
    return submitResponse;
  }
}
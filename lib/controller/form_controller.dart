import 'dart:convert' as convert;
import 'package:fitnesstrackr/model/name.dart';
import 'package:fitnesstrackr/model/workout.dart';
import 'package:http/http.dart' as http;
import '../model/form.dart';

/// FormController is a class which does work of saving FeedbackForm in Google Sheets using 
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class FormController {
  // Callback function to give response of status of current request.
  final void Function(String) callback;
  final void Function(List<Name>) getNamesCallback;
  final void Function(List<Workout>) getWorkoutsCallback;

  // Google App Script Web URL.
  static const String URL = "https://script.google.com/macros/s/AKfycbypIrYS8IVKtRvp68_IBI_a0WRsOwXpIYob16H2SoexGvltRcw/exec";
  
  // Success Status Message
  static const STATUS_SUCCESS = "SUCCESS";

  // Default Contructor
  FormController(this.callback, this.getNamesCallback, this.getWorkoutsCallback);

  void getNames() async {
    try {
      await http.get(
        URL + "?type=getNames"
      ).then((response){
        List<Name> names = (convert.jsonDecode(response.body)['names'] as List).map((i) => Name.fromJSON(i)).toList();
        
        getNamesCallback(names);
      });    
    } catch (e) {
      print(e);
    }
  }

  void getWorkouts() async {
    try {
      await http.get(
        URL + "?type=getWorkouts"
      ).then((response){
        callback(convert.jsonDecode(response.body)['workouts']);
      });    
    } catch (e) {
      print(e);
    }
  }

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  void submitForm(WorkoutForm feedbackForm) async {
    try {
      await http.get(
        URL + feedbackForm.toParams()
      ).then((response){
        callback(convert.jsonDecode(response.body)['status']);
      });    
    } catch (e) {
      print(e);
    }
  }
}
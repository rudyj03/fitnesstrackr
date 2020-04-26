import 'dart:async';
import 'dart:ffi';

import 'package:fitnesstrackr/tabs/workout_entry/name_row.dart';
import 'package:fitnesstrackr/tabs/workout_entry/picker.dart';
import 'package:fitnesstrackr/tabs/workout_entry/validation_dialog.dart';
import 'package:fitnesstrackr/tabs/workout_entry/value_row.dart';
import 'package:fitnesstrackr/tabs/workout_entry/workout_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import '../../styles.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fitnesstrackr/controller/form_controller.dart';
import 'package:fitnesstrackr/model/form.dart';
import 'package:fitnesstrackr/model/workout.dart';
import 'package:fitnesstrackr/model/name.dart';

class WorkoutEntryTab extends StatefulWidget {
  WorkoutEntryTab({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WorkoutEntryTab createState() => _WorkoutEntryTab();
}

class _WorkoutEntryTab extends State<WorkoutEntryTab> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  
  FormController formController = FormController();
  Future<Response> _namesFuture;
  Future<Response> _workoutsFuture;


  Name selectedName = new Name();
  Workout selectedWorkout = new Workout();
  String enteredValue;


  @override
  void initState() {
    _namesFuture = formController.getNames();
    _workoutsFuture = formController.getWorkouts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return 
      CupertinoPageScaffold(
        backgroundColor: Styles.scaffoldBackground,
        child: SafeArea(
            child: CustomScrollView(
              key: _formKey,
              slivers: <Widget> [
                CupertinoSliverRefreshControl(onRefresh: _refresh),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Text("Enter your workout", style: Styles.title, textAlign: TextAlign.center,),
                      Divider(height: 30.0,thickness: 0.0, color: Styles.scaffoldBackground),
                      NameRow(selectedName: selectedName),
                      Picker(
                          future: this._namesFuture,
                          onSelectChange: (Name picked) => setState(() {selectedName = picked;}),
                          jsonConverterFuncion: formController.convertNamesFromJson,
                          fieldName: "name",
                      ),
                      Divider(height: 50.0,thickness: 0.0, color: Styles.scaffoldBackground),
                      WorkoutRow(selectedWorkout: selectedWorkout),
                      Picker(
                        future: this._workoutsFuture,
                        onSelectChange: (Workout picked) => setState(() {selectedWorkout = picked;}),
                        jsonConverterFuncion: formController.convertWorkoutsFromJson,
                        fieldName: "workout",
                      ),
                      Divider(height: 50.0,thickness: 0.0, color: Styles.scaffoldBackground),
                      ValueRow(
                        selectedWorkout: selectedWorkout,
                        onChange: (val) => enteredValue = val,
                      ),
                      Divider(height: 20.0,thickness: 0.0, color: Styles.scaffoldBackground),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CupertinoButton(
                            child: Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              color: Styles.actionButton,
                              size: 50,
                            ),
                            onPressed: () => _submitForm("Submitting..."),
                          ),
                        ]
                      )
                    ]
                  ),
                )
            ]
          )
        )
      );
  }


  Future<AudioPlayer> playSound() async {
    AudioCache cache = new AudioCache();
    return await cache.play("submit_sound.mp3");
  }

  Future<Void> _refresh() {
    var completer = new Completer<Void>();

    //Complete the future and set the state to new futures for names and workouts
    //The picker widget use
    completer.complete();

    SystemSound.play(SystemSoundType.click);
    setState(() {
      _namesFuture = formController.getNames();
      _workoutsFuture = formController.getWorkouts();
      selectedWorkout = Workout();
      selectedName = Name();
    });

    return completer.future;
  }

  _submitForm(String message) {
    FocusScope.of(context).requestFocus(FocusNode());
    bool isValid = _validateForm();
    if(!isValid) {
      return;
    } else {
      WorkoutForm form = WorkoutForm();
      form.workout = selectedWorkout;
      form.name = selectedName;
      form.duration = double.parse(enteredValue);
      formController.submitForm(form)
      .then((response) {
        print(response.body);
        if(response.statusCode == 200){
          playSound().then((audio){
            Fluttertoast.showToast(
              msg: "Your workout has been logged!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Color(0xFF159ead),
              textColor: Colors.black,
              fontSize: 16.0
            );
          });
        }
      });
    }
    
  }

  bool _validateForm() {
    if(selectedWorkout == null || selectedWorkout.name == "") {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return ValidationDialog(message: "Choose a workout/activity!");
        }
      );
      return false;
    }

    if(selectedName == null || selectedName.name == ""){
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return ValidationDialog(message: "Choose a person!");
        }
      );
      return false;
    }

    if(enteredValue == null || double.tryParse(enteredValue) == null) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return ValidationDialog(message: "Enter an integer or decimal.");
        }
      );
      return false;
    }
    return true;
  }
}
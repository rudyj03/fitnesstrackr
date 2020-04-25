import 'package:fitnesstrackr/controller/form_controller.dart';
import 'package:fitnesstrackr/model/form.dart';
import 'package:fitnesstrackr/model/workout.dart';
import 'package:fitnesstrackr/model/name.dart';
import 'package:fitnesstrackr/widgets/picker.dart';
import 'package:fitnesstrackr/widgets/name_row.dart';
import 'package:fitnesstrackr/widgets/validation_dialog.dart';
import 'package:fitnesstrackr/widgets/value_input.dart';
import 'package:fitnesstrackr/widgets/workout_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'styles.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Trackr',
      home: Trackr(title: 'Trackr Home Page'),
    );
  }
}

class Trackr extends StatefulWidget {
  Trackr({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TrackrState createState() => _TrackrState();
}

class _TrackrState extends State<Trackr> {
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
    return CupertinoPageScaffold(
        key: _scaffoldKey,
        navigationBar: CupertinoNavigationBar(
          middle: Text("Fitness Trackr", style: Styles.title,),
          backgroundColor: Styles.navigationBackground,
        ),
        backgroundColor: Styles.scaffoldBackground,
        child: 
          SafeArea(
            child: ListView(
                key: _formKey,
                children: <Widget>[
                  Divider(height: 50.0,thickness: 0.0, color: Styles.scaffoldBackground),
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
                  ValueInput(
                    selectedWorkout: selectedWorkout,
                    onChange: (val) => enteredValue = val,
                  ),
                  Divider(height: 50.0,thickness: 0.0, color: Styles.scaffoldBackground),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                    CupertinoButton(
                        child: Icon(
                          CupertinoIcons.check_mark_circled_solid,
                          color: Styles.submitButton,
                          size: 50,
                        ),
                        onPressed: () => _submitForm("Submitting..."),
                    ),
                    CupertinoButton(
                        child: Icon(
                          CupertinoIcons.refresh_circled,
                          color: Styles.submitButton,
                          size: 50,
                        ),
                        onPressed: () => _refresh(),
                    )
                  ]),
                ],
              
            )
          )
    );
  }


  Future<AudioPlayer> playSound() async {
      AudioCache cache = new AudioCache();
      return await cache.play("submit_sound.mp3");
    }

  _refresh() {
    SystemSound.play(SystemSoundType.click);
    setState(() {
      _namesFuture = formController.getNames();
      _workoutsFuture = formController.getWorkouts();
      selectedWorkout = Workout();
      selectedName = Name();
    });
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

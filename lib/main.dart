import 'package:fitnesstrackr/controller/form_controller.dart';
import 'package:fitnesstrackr/model/form.dart';
import 'package:fitnesstrackr/model/workout.dart';
import 'package:fitnesstrackr/model/name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'styles.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      home: Trackr(title: 'Flutter Demo Home Page'),
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
  final _form = new WorkoutForm();
  List<Workout> _workouts = new List<Workout>();
  List<Name> _names = new List<Name>();
  Name selectedName = new Name();
  Workout selectedWorkout = new Workout();
  FormController formController = FormController();
  Future<Response> _namesFuture;
  Future<Response> _workoutsFuture;
  String enteredDuration;


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
          middle: Text('Trackr'),
          backgroundColor: Colors.blueGrey,
        ),
        backgroundColor: Colors.grey[200],
        child: SafeArea(
          child: Column(
            key: _formKey,
            children: <Widget>[
              nameWidget(),
              Divider(height: 50.0,thickness: 0.0,),
              workoutsWidget(),
              Divider(height: 50.0,thickness: 0.0,),
              durationWidget(),
              Expanded(child: CupertinoButton(
                  child: Text("Submit"),
                  onPressed: () => _submitForm("Submitting..."),
                )
              )
            ],
          )
        )
    );
  }

  Widget nameWidget() {
    return FutureBuilder<Response>(
      future: _namesFuture, // a Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Getting names...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              _names = formController.convertNamesFromJson(snapshot.data.body);
              _names.sort((a, b) => a.name.compareTo(b.name));
              return namePickerRow();
        }
      },
    );
  }

  Widget workoutsWidget() {
    return FutureBuilder<Response>(
      future: _workoutsFuture, // a Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Getting workouts...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              _workouts = formController.convertWorkoutsFromJson(snapshot.data.body);
              _workouts.sort((a,b) => a.workout.compareTo(b.workout));
              return workoutPickerRow();
        }
      },
    );
  }


  Widget namePickerRow() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  CupertinoIcons.person,
                  color: CupertinoColors.systemBlue,
                  size: 28,
                ),
                SizedBox(width: 6),
                Text(
                  'Name',
                  style: Styles.deliveryTimeLabel,
                ),
                SizedBox(width: 25),
                Text(
                  selectedName.name,
                  style: Styles.deliveryTime,
                ),
              ],
            ),
          ]
        ),
        _namePicker()
      ]
    );
  }

  Widget _namePicker() {
    return Container(
      height: 75,
      child: CupertinoPicker(
        magnification: 1.5,
        backgroundColor: Colors.grey[100],
        scrollController: FixedExtentScrollController(initialItem: 0),
        children: List<Widget>.generate(
          _names.length,
          (int i) => Text(_names[i].name, style: Styles.inputs,)
        ),
        itemExtent: 50, //height of each item
        looping: true,
        onSelectedItemChanged: (int i) {
          setState(() {selectedName = _names[i];});
        },
      )
    );
  }

  Widget workoutPickerRow() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  CupertinoIcons.heart,
                  color: CupertinoColors.systemBlue,
                  size: 28,
                ),
                SizedBox(width: 6),
                Text(
                  'Workout',
                  style: Styles.deliveryTimeLabel,
                ),
                SizedBox(width: 25),
                Text(
                  selectedWorkout.workout,
                  style: Styles.deliveryTime,
                ),
              ],
            ),
          ]
        ), 
        _workoutPicker()
      ],
    );
  }

  Widget _workoutPicker() {
    return Container(
      height: 75,
      child: CupertinoPicker(
        magnification: 1.5,
        backgroundColor: Colors.grey[100],
        scrollController: FixedExtentScrollController(initialItem: 0),
        children: List<Widget>.generate(
          _workouts.length,
          (int i) => Text(_workouts[i].workout, style: Styles.inputs,)
        ),
        itemExtent: 50, //height of each item
        looping: true,
        onSelectedItemChanged: (int i) {
          setState(() {selectedWorkout = _workouts[i];});
        },
      )
    );
  }

  Widget durationWidget() {
    var unitsText = selectedWorkout.units == "" ? "" : ' ( in ' + selectedWorkout.units + ' )';
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  CupertinoIcons.clock,
                  color: CupertinoColors.systemBlue,
                  size: 28,
                ),
                SizedBox(width: 6),
                Text(
                  'Duration' + unitsText,
                  style: Styles.deliveryTimeLabel,
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
            style: Styles.inputs,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0,
                  color: CupertinoColors.inactiveGray,
                ),
              ),
            ),
            onChanged: (val) => enteredDuration = val, 
          ),
        )
      ],
    );
  }

  _submitForm(String message) {
    SystemSound.play(SystemSoundType.click);
    WorkoutForm form = WorkoutForm();
    
    form.workout = selectedWorkout;
    form.name = selectedName;
    form.duration = double.parse(enteredDuration);
    formController.submitForm(form)
    .then((response) {
      print(response.body);
      if(response.statusCode == 200){
        Fluttertoast.showToast(
          msg: "Your workout has been logged!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xFF159ead),
          textColor: Colors.black,
          fontSize: 16.0
        );
      }
    });
  }
}

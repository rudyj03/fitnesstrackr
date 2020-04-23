import 'package:fitnesstrackr/controller/form_controller.dart';
import 'package:fitnesstrackr/model/form.dart';
import 'package:fitnesstrackr/model/workout.dart';
import 'package:fitnesstrackr/model/name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'styles.dart';

void main() => runApp(MyApp());

//https://script.google.com/macros/s/AKfycbypIrYS8IVKtRvp68_IBI_a0WRsOwXpIYob16H2SoexGvltRcw/exec
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
  final _form = new WorkoutForm();
  List<Workout> _workouts = new List<Workout>();
  List<Name> _names = new List<Name>();
  Name selectedName = new Name();
  Workout selectedWorkout = new Workout();
  Widget _initChild = Text("Getting data...");

  @override
  void initState() {
    FormController formController = FormController(_submitCallback, _getNamesCallback, _getWorkoutsCallback);
    formController.getNames();
    formController.getWorkouts();
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
        navigationBar: CupertinoNavigationBar(
          middle: Text('Trackr'),
          backgroundColor: Colors.blueGrey,
        ),
        child: SafeArea(
          child: formWidget()
        )
    );
  }

  Widget formWidget() {
    return Column(
      key: _formKey,
      children: <Widget>[
        namePickerRow(),
        namePicker(),
        workoutPickerRow(),
        workoutPicker()
      ],
    );
  }


  Widget namePickerRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                CupertinoIcons.clock,
                color: CupertinoColors.lightBackgroundGray,
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
      );
  }

  Widget namePicker() {
    return Container(
      height: 75,
      child: CupertinoPicker(
        magnification: 1.5,
        backgroundColor: Colors.grey[100],
        scrollController: FixedExtentScrollController(initialItem: 0),
        children: List<Widget>.generate(
          _names.length,
          (int i) => Text(_names[i].name)
        ),
        itemExtent: 50, //height of each item
        looping: true,
        onSelectedItemChanged: (int i) {
          print("Changed to " + _names[i].name);
          setState(() {selectedName = _names[i];});
        },
      )
    );
  }

  Widget workoutPickerRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                CupertinoIcons.heart,
                color: CupertinoColors.lightBackgroundGray,
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
      );
  }

  Widget workoutPicker() {
    return Container(
      height: 75,
      child: CupertinoPicker(
        magnification: 1.5,
        backgroundColor: Colors.grey[100],
        scrollController: FixedExtentScrollController(initialItem: 0),
        children: List<Widget>.generate(
          _names.length,
          (int i) => Text(_workouts[i].workout)
        ),
        itemExtent: 50, //height of each item
        looping: true,
        onSelectedItemChanged: (int i) {
          print("Changed to " + _workouts[i].workout);
          setState(() {selectedName = _names[i];});
        },
      )
    );
  }

  _showDialog() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Hello'),
              content: const Text('Submitting form'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Dismiss'),
                  onPressed: () {
                    Navigator.pop(context, 'Dismiss');
                  },
                )
              ],
            ));
  }

  _getNamesCallback(List<Name> names){
    setState(() {
      _names = names;
      selectedName = _names[0];
      //_initChild = formWidget();
    });
  }

  _getWorkoutsCallback(List<Workout> workouts) {
    workouts.forEach((workout) => print(workout.workout));
    setState(() { 
      _workouts = workouts;
      selectedWorkout = _workouts[0];
    });
  }

  _submitCallback(String status){
    print(status);
  }
}

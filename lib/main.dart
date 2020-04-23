import 'package:fitnesstrackr/controller/form_controller.dart';
import 'package:fitnesstrackr/model/form.dart';
import 'package:fitnesstrackr/model/workout.dart';
import 'package:fitnesstrackr/model/name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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

  @override
  void initState() {
    FormController formController = FormController(_submitCallback, _getNamesCallback);
    formController.getNames();
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(height:75, child: 
                  CupertinoPicker(
                    magnification: 1.5,
                    backgroundColor: Colors.grey[100],
                    children: List<Widget>.generate(
                      _names.length,
                      (int i) {
                          return Text(_names[i].name);
                      }),
                    itemExtent: 50, //height of each item
                    looping: true,
                    onSelectedItemChanged: (int index) {  
                      //selectitem = index;
                    },
                  )
                ),
                Divider(height: 25.0,),
                CupertinoTextField(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  placeholder: 'Enter some text',
                  onChanged: (val) => setState(() => _form.duration = val as double),
                ),
                Divider(height: 25.0,),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: CupertinoButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _showDialog();
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          )
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
    names.forEach((name) => print(name.name));
    setState(() => _names = names);
  }

  _getWorkoutsCallback(List<Workout> workouts) {
    print(workouts);
    setState(() => _workouts = workouts);
  }

  _submitCallback(String status){
    print(status);
  }
}

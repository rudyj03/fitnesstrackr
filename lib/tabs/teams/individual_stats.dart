import 'package:fitnesstrackr/controller/form_controller.dart';
import 'package:fitnesstrackr/model/player_workout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

import '../../styles.dart';

class IndividualStats extends StatelessWidget {
  final String playerName;

  IndividualStats({Key key, this.playerName}) : super(key: key);


  @override
  Widget build(BuildContext context){
    return CupertinoPageScaffold(
      backgroundColor: Styles.scaffoldBackground,
      child:
        SafeArea(
          child: CustomScrollView(
            slivers: <Widget> [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Divider(height: 50.0,thickness: 0.0, color: Styles.scaffoldBackground),
                    statsWidget(),
                  ])
                ),
              ]
            )
        )
    );
  }

  Widget statsWidget() {
    FormController formController = new FormController();
    return FutureBuilder<Response>(
      future: formController.getPlayerStats(playerName), // a Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return NutsActivityIndicator(inactiveColor: CupertinoColors.systemGrey2);
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              PlayerWorkout playerStats = PlayerWorkout();
              //Weak check for if there was an error, but Google apps script doesn't return error codes :-(
              if(snapshot.data.headers.length >= 14){
                playerStats = formController.convertPlayerStatsFromJson(snapshot.data.body);
              } else {
                return Text("There was an erroring retrieving data, please try again later");
              }

              List<TableRow> rows = List<TableRow>();
              List<WorkoutInfo> workoutInfo = playerStats.workoutInfo;

             rows.addAll(List.generate(workoutInfo.length, (index) 
                { 
                  var workoutObject = workoutInfo[index];
                  var amountText = workoutObject.units == "Count" || workoutObject.units.contains("Y=1") ?
                          workoutObject.amount.toString() : 
                          workoutObject.amount.toString() + " " + workoutObject.units;
                  return TableRow(
                      children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(workoutObject.workout)
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(amountText)
                      )
                    ]
                  );
                }    
              ));
              
              //Add row for total
              rows.add(TableRow(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text("Total Score")
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(playerStats.totalScore.toString())
                        )
                    ]
                  )
                );

              return Column(
                  children: <Widget>[
                  CupertinoNavigationBar(
                    backgroundColor: Styles.scaffoldBackground,
                    middle: Text(playerName, style: Styles.title, textAlign: TextAlign.center,)
                  ),
                  Table(
                    columnWidths: {0: FixedColumnWidth(200), 1: FixedColumnWidth(150)},
                    children: rows
                  ),
                ]
              );
            }
        }
      },
    );
  } 
}
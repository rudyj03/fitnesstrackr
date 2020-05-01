import 'package:fitnesstrackr/controller/form_controller.dart';
import 'package:fitnesstrackr/model/team.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

import '../../styles.dart';
import 'individual_stats.dart';

class Teams extends StatelessWidget {
  final Future future;
  final Function jsonConverterFuncion;


  const Teams({Key key, this.future, this.jsonConverterFuncion})
      : super(key: key);


  @override
  Widget build(BuildContext context){
    return FutureBuilder<Response>(
      future: future, // a Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return NutsActivityIndicator(inactiveColor: CupertinoColors.systemGrey2);
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              List<Team> teams = List();
              //Weak check for if there was an error, but Google apps script doesn't return error codes :-(
              if(snapshot.data.headers.length >= 14){
                teams = jsonConverterFuncion(snapshot.data.body);
                teams.sort((a, b) => a.teamName.compareTo(b.teamName));
              } else {
                return Text("There was an erroring retrieving data, please try again later");
              }
              List<TableRow> tableRows = List<TableRow>();

              teams.forEach((team) {
                  tableRows.add(TableRow(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal:50.0, vertical: 20.0),
                        child: Text(team.teamName)
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          children: new List.generate(team.members.length,
                              (index) => Padding(
                                            padding: EdgeInsets.symmetric(vertical: 5.0),
                                            child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context, CupertinoPageRoute(
                                                            builder: (context) => IndividualStats(
                                                              formController: new FormController(),
                                                              playerName: team.members[index],
                                                            )
                                                          )
                                                        );
                                                    },
                                                    child: Text(team.members[index], style: Styles.playerNameLink)
                                                  )
                                          )
                              ),
                          ),
                      )
                    ]
                  ));
                }
              );

              return Table(
                columnWidths: {0: FixedColumnWidth(20), 1: FixedColumnWidth(50)},
                border: TableBorder.symmetric(outside: BorderSide.none),
                children: tableRows,
              );
            }
        }
      },
    );
  }
}
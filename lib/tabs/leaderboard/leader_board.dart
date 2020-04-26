import 'package:fitnesstrackr/model/leadboard_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

class LeaderBoard extends StatelessWidget {
  final Future future;
  final Function jsonConverterFuncion;


  const LeaderBoard({Key key, this.future, this.jsonConverterFuncion})
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
              List<LeaderboardEntry> leaderBoard = List();
              //Weak check for if there was an error, but Google apps script doesn't return error codes :-(
              if(snapshot.data.headers.length >= 14){
                leaderBoard = jsonConverterFuncion(snapshot.data.body);
                leaderBoard.sort((a, b) => a.rank.compareTo(b.rank));
              } else {
                return Text("There was an erroring retrieving data, please try again later");
              }
              List<TableRow> tableRows = List<TableRow>();
              tableRows.add(TableRow(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:50.0, vertical: 5.0),
                      child: Text("Rank")
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text("Name")
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text("Score")
                    ),
                  ]
                ));
              leaderBoard.forEach((leaderBoardEntry) {
                  tableRows.add(TableRow(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal:50.0, vertical: 5.0),
                        child: Text(leaderBoardEntry.rank.toString())
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(leaderBoardEntry.name)
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(leaderBoardEntry.score.toString())
                      ),
                    ]
                  ));
                }
              );
              return Table(
                columnWidths: {0: FixedColumnWidth(80), 1: FixedColumnWidth(80), 2: FixedColumnWidth(10)},
                border: TableBorder.symmetric(outside: BorderSide.none),
                children: tableRows,
              );
            }
        }
      },
    );
  }
}
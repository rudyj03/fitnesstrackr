import 'package:fitnesstrackr/model/leadboard_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import '../../styles.dart';

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
          case ConnectionState.waiting: return CupertinoActivityIndicator(animating: true,);
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
               leaderBoard.forEach((leaderBoardEntry) {
                  tableRows.add(TableRow(children: [
                      Column(children: <Widget>[
                        Text(leaderBoardEntry.rank.toString())
                      ]),
                      Column(children: <Widget>[
                        Text(leaderBoardEntry.name)
                      ]),
                      Column(children: <Widget>[
                        Text(leaderBoardEntry.score.toString())
                      ])
                    ]
                  ));
                }
              );

              return Container(
                margin: EdgeInsets.all(10),
                child: Table(
                  border: TableBorder.all(),
                  children: tableRows,
                )
              );
            }
        }
      },
    );
  }
}
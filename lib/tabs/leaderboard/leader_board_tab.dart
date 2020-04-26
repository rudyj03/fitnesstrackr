import 'dart:async';
import 'dart:ffi';
import 'package:fitnesstrackr/tabs/leaderboard/leader_board.dart';
import 'package:flutter/services.dart';

import 'package:fitnesstrackr/controller/form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../../styles.dart';

class LeadboardTab extends StatefulWidget {
  LeadboardTab({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LeadboardTab createState() => _LeadboardTab();
}

class _LeadboardTab extends State<LeadboardTab> {
  Future<Response> _leaderboardFuture;
  FormController formController = FormController();

  @override
  void initState() {
    _leaderboardFuture = formController.getLeaderboard();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return 
    CupertinoPageScaffold(
      backgroundColor: Styles.scaffoldBackground,
      child:
        SafeArea(
          child: CustomScrollView(
            slivers: <Widget> [
                CupertinoSliverRefreshControl(onRefresh: _refresh,),
                SliverToBoxAdapter(child: Column(
                  children: <Widget>[
                    Text("Leaderboard", style: Styles.title)
                  ]
                )),
                SliverToBoxAdapter(child: Divider(height: 50.0,thickness: 0.0, color: Styles.scaffoldBackground)),
                SliverToBoxAdapter(child: LeaderBoard(
                  future: _leaderboardFuture, 
                  jsonConverterFuncion: formController.convertLeaderboardFromJson)
                ),
              ]
            )
        )
    );
  }

  Future<Void> _refresh() {
    var completer = new Completer<Void>();

    //Complete the future and set the state to new futures for names and workouts
    //The picker widget use
    completer.complete();

    SystemSound.play(SystemSoundType.click);
    setState(() {
      _leaderboardFuture = formController.getLeaderboard();
    });
    return completer.future;
  }
}

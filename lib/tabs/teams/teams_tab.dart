import 'dart:async';
import 'dart:ffi';
import 'package:flutter/services.dart';

import 'package:fitnesstrackr/controller/form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../../styles.dart';
import 'teams.dart';

class TeamsTab extends StatefulWidget {
  TeamsTab({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TeamsTab createState() => _TeamsTab();
}

class _TeamsTab extends State<TeamsTab> {
  Future<Response> _teamsFuture;
  FormController formController = FormController();

  @override
  void initState() {
    _teamsFuture = formController.getTeams();
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
                CupertinoSliverNavigationBar(
                  backgroundColor: Styles.scaffoldBackground,
                  largeTitle: Text("Teams", style: Styles.title, textAlign: TextAlign.center,)
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Divider(height: 50.0,thickness: 0.0, color: Styles.scaffoldBackground),
                    Teams(
                      future: _teamsFuture, 
                      jsonConverterFuncion: formController.convertTeamsFromJson
                    )
                  ])
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
      _teamsFuture = formController.getTeams();
    });
    return completer.future;
  }
}

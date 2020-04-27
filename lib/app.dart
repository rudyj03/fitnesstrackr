import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'styles.dart';
import 'tabs/teams/teams_tab.dart';
import 'tabs/workout_entry/workout_entry_tab.dart';
import 'tabs/leaderboard/leader_board_tab.dart';

class Trackr extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 15.0),
          middle: Image.asset('assets/images/ftbanner.png'),
          backgroundColor: Styles.navigationBackground
        ),
        backgroundColor: Styles.scaffoldBackground,
        child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Styles.tabBackground,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              title: Text('Workout'),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              title: Text('Teams'),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.flag),
              title: Text('Leaderboard'),
            ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: WorkoutEntryTab(),
                );
              });
            case 1:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: TeamsTab(),
                );
              });
            case 2:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: LeadboardTab(),
                );
              });
          }
        },
      ),
    );
    
    }
}
import 'dart:convert';
import 'dart:math';

import 'package:Risky_Biscuits/components/slide-right-nav.dart';
import 'package:Risky_Biscuits/components/team-tile.dart';
import 'package:Risky_Biscuits/models/team.model.dart';
import 'package:Risky_Biscuits/screens/create-team.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeamsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TeamsPageState();
  }
}

class _TeamsPageState extends State<TeamsPage> {
  @override
  Widget build(BuildContext context) {
    var teamsList = FutureBuilder(
      future: _getTeams(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else if (snapshot.data.length == 0) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('You are not currently a part of a team.'),
                    Padding(padding: EdgeInsets.only(top: 5),
                    child: Random().nextBool() == true ? Text('how lonely...') : Text('teamwork makes the dreamwork!'),),
                    FlatButton(
                      child: Text('create one now'),
                      onPressed: _createTeamPage,
                      textColor: Theme.of(context).accentColor,
                    )
                  ],
                ),
              );
            } else
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    TeamModel currentTeam = snapshot.data[index];
                    return TeamTile(
                      team: currentTeam,
                      onTap: () {Navigator.push(context, SlideRightRoute(page: CreateTeamPage()));},
                    );
                  });
        }
      },
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _createTeamPage,
      ),
      body: teamsList,
    );
  }

  Future<List<TeamModel>> _getTeams() async {
    List<TeamModel> teams;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var result =
        await http.get("http://10.0.2.2:54732/api/teams?authId=${user.uid}");
    if (result.statusCode == 200) {
      var data = json.decode(result.body) as List;
      teams = data.map<TeamModel>((t) => TeamModel.fromJson(t)).toList();
    }
    return teams;
  }

  void _createTeamPage() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateTeamPage()));
  }
}

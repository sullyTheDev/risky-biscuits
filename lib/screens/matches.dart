import 'dart:convert';

import 'package:Risky_Biscuits/components/leaderboard-tile.dart';
import 'package:Risky_Biscuits/components/score-tile.dart';
import 'package:Risky_Biscuits/models/leaderboard.model.dart';
import 'package:Risky_Biscuits/models/match.model.dart';
import 'package:Risky_Biscuits/screens/create-match.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MatchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MatchPageState();
  }
}

class _MatchPageState extends State<MatchPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            return Scaffold(
              appBar: AppBar(title: const Text('Upcoming Matches')),
              body: Center(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        MatchModel currentModel = snapshot.data[index];
                        return Padding(
                            padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 0.0),
                            child: ScoreTile(
                              team1Name: currentModel.challengerName,
                              team2Name: currentModel.oppositionName,
                              team1Score: currentModel.challengerScore,
                              team2Score: currentModel.oppositionScore,
                              matchDate: currentModel.matchDate,
                            ));
                      })),
              floatingActionButton: FloatingActionButton(
                onPressed: () => setState(() => {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateMatchPage()))
                    }),
                child: const Icon(Icons.add),
              ),
            );
        }
      },
      future: _getMatches(),
    );
  }

  Future<List<MatchModel>> _getMatches() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    List<MatchModel> results;
    var result = await http
        .get('http://10.0.2.2:54732/api/match?future=true&authId=${user.uid}');
    if (result.statusCode == 200) {
      print(result.body);
      var data = json.decode(result.body) as List;
      results = data.map<MatchModel>((j) => MatchModel.fromJson(j)).toList();
    }
    return results;
  }
}

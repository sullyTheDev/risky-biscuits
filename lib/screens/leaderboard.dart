import 'dart:convert';

import 'package:Risky_Biscuits/components/leaderboard-tile.dart';
import 'package:Risky_Biscuits/components/score-tile.dart';
import 'package:Risky_Biscuits/models/leaderboard.model.dart';
import 'package:Risky_Biscuits/models/match.model.dart';
import 'package:Risky_Biscuits/models/team.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeaderboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LeaderboardPageState();
  }
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                LeaderboardModel currentModel = snapshot.data[index];
                return LeaderboardTile(
                  teamName: currentModel.name,
                  elo: currentModel.elo,
                  wins: currentModel.wins,
                  losses: currentModel.losses,
                  teamColor: currentModel.color,
                  rank: currentModel.rank,
                );
              },
            );
        }
      },
      future: _getMatches(),
    );
  }

  Future<List<LeaderboardModel>> _getMatches() async {
    List<LeaderboardModel> results;
    var result =
        await http.get('http://10.0.2.2:54732/api/team-records?rulesetId=2');
    if (result.statusCode == 200) {
      print(result.body);
      var data = json.decode(result.body) as List;
      results = data
          .map<LeaderboardModel>((j) => LeaderboardModel.fromJson(j))
          .toList();

      for (int i = 0; i < results.length; i++) {
        results[i].rank = (i + 1);
      }
    }
    return results;
  }
}

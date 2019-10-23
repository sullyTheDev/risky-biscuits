import 'dart:convert';

import 'package:first_app/components/leaderboard-tile.dart';
import 'package:first_app/components/score-tile.dart';
import 'package:first_app/models/leaderboard.model.dart';
import 'package:first_app/models/match.model.dart';
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
    }
    return results;
  }
}

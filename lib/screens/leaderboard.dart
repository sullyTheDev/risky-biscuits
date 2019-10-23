import 'dart:convert';

import 'package:first_app/components/score-tile.dart';
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
            return new Text('leaderboard');
        }
      },
      future: _getMatches(),
    );
  }

  Future<List<MatchModel>> _getMatches() async {
    List<MatchModel> matches;
    var result = await http.get('http://10.0.2.2:54732/api/match');
    if (result.statusCode == 200) {
      print(result.body);
      var data = json.decode(result.body) as List;
      matches = data.map<MatchModel>((j) => MatchModel.fromJson(j)).toList();
    }
    return matches;
  }
}

import 'dart:convert';

import 'package:first_app/components/score-tile.dart';
import 'package:first_app/models/match.model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScoresPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScoresPageState();
  }
}

class _ScoresPageState extends State<ScoresPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              print(snapshot.data);
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                MatchModel currentModel = snapshot.data[index];
                return ScoreTile(
                  team1Name: currentModel.challengerName,
                  team2Name: currentModel.oppositionName,
                  team1Score: currentModel.challengerScore,
                  team2Score: currentModel.oppositionScore,
                  matchDate: currentModel.matchDate,
                );
              },
            );
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

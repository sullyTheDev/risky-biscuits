import 'dart:core';

import 'package:Risky_Biscuits/models/team.model.dart';

class LeaderboardModel {
  int teamId, rulesetId, elo, wins, losses, rank;
  String name, color;

  LeaderboardModel(
      {this.teamId,
      this.rulesetId,
      this.elo,
      this.wins,
      this.losses,
      this.name,
      this.color});
  LeaderboardModel.fromJson(Map<String, dynamic> data)
      : teamId = data['teamId'],
        rulesetId = data['rulesetId'],
        elo = data['elo'],
        wins = data['wins'],
        losses = data['losses'],
        name = data['name'],
        color = data['color'];
}

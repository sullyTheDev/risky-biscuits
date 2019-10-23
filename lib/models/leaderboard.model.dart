import 'dart:core';

class LeaderboardModel {
  int teamId, rulesetId, elo, wins, losses;
  String name;

  LeaderboardModel(
      {this.teamId,
      this.rulesetId,
      this.elo,
      this.wins,
      this.losses,
      this.name});
  LeaderboardModel.fromJson(Map<String, dynamic> data)
      : teamId = data['teamId'],
        rulesetId = data['rulesetId'],
        elo = data['elo'],
        wins = data['wins'],
        losses = data['losses'],
        name = data['name'];
}

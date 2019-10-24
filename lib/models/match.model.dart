import 'dart:core';

import 'package:Risky_Biscuits/models/leaderboard.model.dart';

class MatchModel {
  int id, challengerId, oppositionId, challengerScore, oppositionScore, rulesetId;
  String challengerName, oppositionName, oppositionColor, challengerColor;
  DateTime matchDate;
  LeaderboardModel challengerRecord, oppositionRecord;

  MatchModel(
      {this.id,
      this.challengerId,
      this.oppositionId,
      this.challengerScore,
      this.oppositionScore,
      this.challengerName,
      this.oppositionName,
      this.matchDate,
      this.oppositionColor,
      this.challengerColor,
      this.rulesetId});
  MatchModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        challengerId = data['challengerId'],
        oppositionId = data['oppositionId'],
        challengerName = data['challengerName'],
        oppositionName = data['oppositionName'],
        challengerScore = data['challengerScore'],
        oppositionScore = data['oppositionScore'],
        oppositionColor = data['oppositionColor'],
        challengerColor = data['challengerColor'],
        matchDate = DateTime.parse(data['matchDate']),
        challengerRecord = LeaderboardModel.fromJson(data['challengerRecord']),
        oppositionRecord = LeaderboardModel.fromJson(data['oppositionRecord']),
        rulesetId = data['rulesetId'];

  Map toMap() {
    var map = new Map<String, String>();
    map['challengerId'] = this.challengerId.toString();
    map['oppositionId'] = this.oppositionId.toString();
    map['matchDate'] = this.matchDate.toString();
    map['rulesetId'] = this.rulesetId.toString();
    return map;
  }
}

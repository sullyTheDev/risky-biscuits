import 'dart:core';

class MatchModel {
  int id, challengerId, oppositionId, challengerScore, oppositionScore;
  String challengerName, oppositionName;
  DateTime matchDate;

  MatchModel(
      {this.id,
      this.challengerId,
      this.oppositionId,
      this.challengerScore,
      this.oppositionScore,
      this.challengerName,
      this.oppositionName,
      this.matchDate});
  MatchModel.fromJson(Map<String, dynamic> data)
  : id = data['id'],
    challengerId = data['challengerId'],
    oppositionId = data['oppositionId'],
    challengerName = data['challengerName'],
    oppositionName = data['oppositionName'],
    challengerScore = data['challengerScore'],
    oppositionScore = data['oppositionScore'],
    matchDate = DateTime.parse(data['matchDate']);
}

import 'package:flutter/material.dart';

class ScoreTile extends StatelessWidget {
  final String team1Name, team2Name;
  final DateTime matchDate;
  final int team1Score, team2Score;
  ScoreTile(
      {Key key,
      this.team1Name,
      this.team2Name,
      this.team1Score,
      this.team2Score,
      this.matchDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Column(children: <Widget>[
          Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: _ScoreTileTeamData(
                team1Name: this.team1Name,
                team2Name: this.team2Name,
                team1Score: this.team1Score,
                team2Score: this.team2Score,
                matchDate: this.matchDate,
              ),
            ),
          ],
        ),
        Divider(),
        ],));
  }
}

class _ScoreTileTeamData extends StatefulWidget {
  final String team1Name, team2Name;
  final DateTime matchDate;
  final int team1Score, team2Score;

  _ScoreTileTeamData({this.team1Name, this.team2Name, this.team1Score, this.team2Score, this.matchDate});

  @override
  State<StatefulWidget> createState() {
    return _ScoreTileTeamDataState();
  }
}

class _ScoreTileTeamDataState extends State<_ScoreTileTeamData> {
   String team1Name, team2Name;
   DateTime matchDate;
   int team1Score, team2Score;
  
  @override
  void initState() {
    super.initState();
    this.team1Name = widget.team1Name;
    this.team2Name = widget.team2Name;
    this.matchDate = widget.matchDate;
    this.team1Score = widget.team1Score;
    this.team2Score = widget.team2Score;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            this.matchDate.toString(),
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.0),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 2.0),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Row(
                  children: <Widget>[ 
                    _isWinner(this.team1Score, this.team2Score)? Flexible(child: Icon(Icons.star, size: 12.0,),): new Container(width: 12.0, height: 0,),
                    Padding(padding: EdgeInsets.fromLTRB(2.0, 0, 0, 0),),
                    Text(this.team1Name,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                  ],
                )
              ),
              Flexible(
                flex: 1,
                child: Text(
                  this.team1Score != null ? this.team1Score.toString(): '',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 2.0),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Row(
                  children: <Widget>[ 
                    _isWinner(this.team2Score, this.team1Score)? Flexible(child: Icon(Icons.star, size: 12.0,),): new Container(width: 12.0, height: 0,),
                    Padding(padding: EdgeInsets.fromLTRB(2.0, 0, 0, 0),),
                    Text(this.team2Name,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                  ],
                )
              ),
              Flexible(
                flex: 1,
                child: Text(
                  this.team2Score != null ? this.team2Score.toString(): '',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  bool _isWinner(int conditionScore, int compareScore) {
    if(conditionScore == null || compareScore == null) {
      return false;
    }
    return conditionScore > compareScore;
  }
}

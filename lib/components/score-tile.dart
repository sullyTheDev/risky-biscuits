import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class ScoreTile extends StatelessWidget {
  final String team1Name, team2Name, team1Color, team2Color;
  final DateTime matchDate;
  final int team1Score, team2Score;
  ScoreTile(
      {Key key,
      this.team1Name,
      this.team2Name,
      this.team1Score,
      this.team2Score,
      this.team1Color,
      this.team2Color,
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
                team1Color: this.team1Color,
                team2Color: this.team2Color,
                matchDate: this.matchDate,
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey, height: 5.0,),
        ],));
  }
}

class _ScoreTileTeamData extends StatefulWidget {
  final String team1Name, team2Name, team1Color, team2Color;
  final DateTime matchDate;
  final int team1Score, team2Score;

  _ScoreTileTeamData({this.team1Name, this.team2Name, this.team1Score, this.team2Score, this.matchDate, this.team1Color, this.team2Color});

  @override
  State<StatefulWidget> createState() {
    return _ScoreTileTeamDataState();
  }
}

class _ScoreTileTeamDataState extends State<_ScoreTileTeamData> {
   String team1Name, team2Name, team1Color, team2Color;
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
    this.team1Color = widget.team1Color;
    this.team2Color = widget.team2Color;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            DateFormat('EEE, MM/dd h:mm a').format(this.matchDate),
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
                    CircleAvatar(
                      maxRadius: 14.0,
        backgroundColor: Color(int.parse(this.team1Color)),
        child: Text(_avatarText(this.team1Name), maxLines: 1, textAlign: TextAlign.center,style: TextStyle(fontSize: 14),),
        foregroundColor: Colors.white,
      ),
      Padding(padding: EdgeInsets.fromLTRB(2.0, 0, 0, 0),),
                    Text(this.team1Name,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
      Padding(padding: EdgeInsets.fromLTRB(0.0, 0, 2.0, 0),),
      _isWinner(this.team1Score, this.team2Score)? Flexible(child: Icon(Icons.star, size: 12.0,),): new Container(width: 12.0, height: 0,),
                  ],
                )
              ),
              Flexible(
                flex: 1,
                child: Text(
                  this.team1Score != null ? this.team1Score.toString(): 'TBD',
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
                    CircleAvatar(
                      maxRadius: 14.0,
        backgroundColor: Color(int.parse(this.team2Color)),
        child: Text(_avatarText(this.team2Name), maxLines: 1, textAlign: TextAlign.center, style: TextStyle(fontSize: 14),),
        foregroundColor: Colors.white,
      ),
      Padding(padding: EdgeInsets.fromLTRB(2.0, 0, 0, 0),),
                    Text(this.team2Name,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                        Padding(padding: EdgeInsets.fromLTRB(0.0, 0, 2.0, 0),),
                        _isWinner(this.team2Score, this.team1Score)? Flexible(child: Icon(Icons.star, size: 12.0,),): new Container(width: 12.0, height: 0,),
                  ],
                )
              ),
              Flexible(
                flex: 1,
                child: Text(
                  this.team2Score != null ? this.team2Score.toString(): 'TBD',
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

  String _avatarText(String name) {
    String result = '';
    name = name.trim();
    var pieces = name.split(' ');

    pieces.forEach((p) {
      result = result + p.substring(0, 1).toUpperCase();
    });

    return result;
  }
}

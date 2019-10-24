import 'package:Risky_Biscuits/models/match.model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScoreTile extends StatelessWidget {
  final MatchModel match;
  final Function onTap; 
  ScoreTile({Key key, this.match, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector( onTap: onTap, child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: <Widget>[
            Padding(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: _ScoreTileTeamData(
                      match: this.match,
                    ),
                  ),
                  IconButton(icon: Icon(Icons.chevron_right),)
                ],
              ),
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
            ),
            Divider(
              color: Colors.grey,
              height: 1.0,
            ),
          ],
        )));
  }
}

class _ScoreTileTeamData extends StatefulWidget {
  final MatchModel match;

  _ScoreTileTeamData({this.match});

  @override
  State<StatefulWidget> createState() {
    return _ScoreTileTeamDataState();
  }
}

class _ScoreTileTeamDataState extends State<_ScoreTileTeamData> {
  MatchModel match;
  Function _onTap;

  @override
  void initState() {
    super.initState();
    this.match = widget.match;
    this._onTap = _onTap;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          DateFormat('EEE, MM/dd h:mm a').format(this.match.matchDate),
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.0),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
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
                      backgroundColor:
                          Color(int.parse(this.match.challengerColor)),
                      child: Text(
                        _avatarText(this.match.challengerName),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      foregroundColor: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                    ),
                    Text(this.match.challengerName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16.0)),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0, 10.0, 0),
                    ),
                    _winLoss(this.match.challengerRecord.wins,
                        this.match.challengerRecord.losses),
                  ],
                )),
            Flexible(
              flex: 1,
              child: Text(
                this.match.challengerScore != null
                    ? this.match.challengerScore.toString()
                    : 'TBD',
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
                      backgroundColor:
                          Color(int.parse(this.match.oppositionColor)),
                      child: Text(
                        _avatarText(this.match.oppositionName),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      foregroundColor: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                    ),
                    Text(this.match.oppositionName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16.0)),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0, 10.0, 0),
                    ),
                    _winLoss(this.match.oppositionRecord.wins,
                        this.match.oppositionRecord.losses),
                  ],
                )),
            Flexible(
              flex: 1,
              child: Text(
                this.match.oppositionScore != null
                    ? this.match.oppositionScore.toString()
                    : 'TBD',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
              ),
            )
          ],
        ),
      ],
    ), onTap: _onTap,);
  }

  Widget _winLoss(int wins, int losses) {
    return Text(
      "$wins-$losses",
      style: TextStyle(fontSize: 12.0),
    );
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

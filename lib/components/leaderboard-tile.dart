import 'package:flutter/material.dart';

class LeaderboardTile extends StatelessWidget {
  final String teamName;
  final int elo, wins, losses;
  LeaderboardTile({Key key, this.teamName, this.elo, this.wins, this.losses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: _LeaderboardTileData(
                    teamName: this.teamName,
                    elo: this.elo,
                    wins: this.wins,
                    losses: this.losses,
                  ),
                ),
              ],
            ),
            Divider(),
          ],
        ));
  }
}

class _LeaderboardTileData extends StatefulWidget {
  final String teamName;
  final int elo, wins, losses;

  _LeaderboardTileData({this.teamName, this.elo, this.wins, this.losses});

  @override
  State<StatefulWidget> createState() {
    return _LeaderboardTileDataState();
  }
}

class _LeaderboardTileDataState extends State<_LeaderboardTileData> {
  String teamName;
  int elo, wins, losses;

  @override
  void initState() {
    super.initState();
    this.teamName = widget.teamName;
    this.elo = widget.elo;
    this.wins = widget.wins;
    this.losses = widget.losses;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            this.teamName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
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
                      Text('Wins: ' + this.wins.toString()),
                    ],
                  )),
              Flexible(
                flex: 1,
                child: Text(this.elo.toString()),
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
                      Text('Losses: ' + this.losses.toString())
                    ],
                  ))
            ],
          ),
        ],
      ),
    );
  }
}

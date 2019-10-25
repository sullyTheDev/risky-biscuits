import 'package:flutter/material.dart';

class LeaderboardTile extends StatelessWidget {
  final String teamName;
  final String teamColor;
  final int elo, wins, losses, rank;
  LeaderboardTile(
      {Key key,
      this.teamName,
      this.elo,
      this.wins,
      this.losses,
      this.teamColor,
      this.rank})
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
                      teamColor: this.teamColor,
                      rank: this.rank),
                ),
              ],
            ),
            Divider(),
          ],
        ));
  }
}

class _LeaderboardTileData extends StatefulWidget {
  final String teamName, teamColor;
  final int elo, wins, losses, rank;

  _LeaderboardTileData(
      {this.teamName,
      this.elo,
      this.wins,
      this.losses,
      this.teamColor,
      this.rank});

  @override
  State<StatefulWidget> createState() {
    return _LeaderboardTileDataState();
  }
}

class _LeaderboardTileDataState extends State<_LeaderboardTileData> {
  String teamName, teamColor;
  int elo, wins, losses, rank;

  @override
  void initState() {
    super.initState();
    this.teamName = widget.teamName;
    this.elo = widget.elo;
    this.wins = widget.wins;
    this.losses = widget.losses;
    this.teamColor = widget.teamColor;
    this.rank = widget.rank;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: ListTile(
            isThreeLine: true,
            trailing: Text('Elo: ' + this.elo.toString()),
            leading: CircleAvatar(
              backgroundColor: Color(int.parse(this.teamColor)),
              child: Text(
                _avatarText(this.teamName),
                overflow: TextOverflow.fade,
              ),
              foregroundColor: Colors.white,
            ),
            title: Text(this.teamName),
            subtitle: Text(this.wins.toString() +
                ' - ' +
                this.losses.toString() +
                '\nRank: ' +
                this.rank.toString()),
          ),
        ),
      ],
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

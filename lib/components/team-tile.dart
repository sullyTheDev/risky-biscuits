import 'package:Risky_Biscuits/models/team.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TeamTile extends StatefulWidget {
  final TeamModel team;
  final Function onTap;

  TeamTile({Key key, this.team, this.onTap}):super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _TeamTileState();
  }

}

class _TeamTileState extends State<TeamTile> {
  TeamModel team;
  Function onTap;
  @override
  void initState() {
    super.initState();
    this.team = widget.team;
    this.onTap = widget.onTap;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Slidable(
  actionPane: SlidableDrawerActionPane(),
  actionExtentRatio: 0.25,
  child: Container(
    color: Colors.white,
    child: ListTile(
      onTap: this.onTap,
      leading: CircleAvatar(
        backgroundColor: Color(int.parse(this.team.color)),
        child: Text(_avatarText(this.team.name), overflow: TextOverflow.fade,),
        foregroundColor: Colors.white,
      ),
      title: Text(this.team.name),
    ),
  ),
  secondaryActions: <Widget>[
    IconSlideAction(
      caption: 'Leave',
      color: Colors.red,
      icon: Icons.delete,
      onTap: () => {},
    ),
  ],
),
Divider()
    ],);
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
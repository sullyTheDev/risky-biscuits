import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/sign_in.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({
    Key key,
    this.user
  }) : super(key: key);
  final FirebaseUser user;

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
        BottomNavigationBarItem(icon: Icon(Icons.hot_tub), title: Text('Hot Tub?')),
        BottomNavigationBarItem(icon: Icon(Icons.store), title: Text('Store')),
        BottomNavigationBarItem(icon: Icon(Icons.local_play), title: Text('Tickets')),
      ],
      backgroundColor: Colors.white,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.black,
      unselectedLabelStyle: TextStyle(color: Colors.black),
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
      currentIndex: _selectedIndex,),
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[Icon(Icons.perm_identity)],
      ),
      body: RaisedButton(child: Text('test logout'),
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
      },),
    );
  }
}

import 'package:my_stock/bloc/blocks/user_bloc_provider.dart';
import '../../bloc/resources/api.dart';
import 'package:my_stock/bloc/resources/repository.dart';
import 'package:my_stock/models/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerMenu extends StatefulWidget {
  final VoidCallback logout;
  final String apiKey;

  DrawerMenu({Key key, this.logout, this.apiKey}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  UserBloc userBloc;
  Repository _repository = Repository();
  User user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setInfo(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          user = snapshot.data;
        } else {
          print("No User");
        }
        return user != null ? buildDraw() : closeUser();
      },
    );
  }

  void login() {
    setState(() {
      build(context);
    });
  }

  Future getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("Username"); //key

    return username;
  }

  Future setInfo() async {
    var username = await getUsername();
    user = await _repository.getUserInfo(widget.apiKey, username);
    return user;
  }

  @override
  Widget buildDraw() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("${user.username}"),
            accountEmail: Text("${user.email}"),
            currentAccountPicture: CircleAvatar(
              child: Text(
                "A",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            title: Text('Log Out'),
            leading: Icon(Icons.directions_walk),
            onTap: () {
              widget.logout();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget closeUser() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            title: Text('Log Out'),
            leading: Icon(Icons.directions_walk),
            onTap: () {
              widget.logout();
            },
          ),
        ],
      ),
    );
  }
}

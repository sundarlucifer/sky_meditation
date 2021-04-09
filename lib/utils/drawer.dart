import 'package:flutter/material.dart';
import 'package:sky_meditation/screens/screens.dart';
import 'package:sky_meditation/models/models.dart';
import 'package:sky_meditation/services/services.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String _userName;
  String _userMail;
  Widget _userPhoto;

  @override
  void initState() {
    User user = authService.user;
    setState(() {
      _userName = user.displayName;
      _userMail = user.email;
      if (user.photoUrl != '') _userPhoto = Image.network(user.photoUrl);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_userName ?? 'anonymous'),
              accountEmail: Text(_userMail ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: _userPhoto,
              ),
            ),
            ListTile(
              title: Text('Home'),
              leading: Icon(Icons.dashboard),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, HomePage.TAG),
            ),
            ListTile(
              title: Text('History'),
              leading: Icon(Icons.date_range_outlined),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, SessionsListPage.TAG),
            ),
            ListTile(
              title: Text('Notes'),
              leading: Icon(Icons.text_snippet_outlined),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, NotesPage.TAG),
            ),
            ListTile(
              title: Text('Profile'),
              leading: Icon(Icons.person),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, ProfilePage.TAG),
            ),
            ListTile(
              title: Text('Sign Out', style: TextStyle(color: Colors.red)),
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              onTap: () => authService.signOut().then((_) =>
                  Navigator.pushReplacementNamed(context, LoginPage.TAG)),
            ),
          ],
        ),
      ),
    );
  }
}

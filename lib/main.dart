import 'package:flutter/material.dart';
import 'package:sky_meditation/services/services.dart';
import 'screens/screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _routes = <String, WidgetBuilder>{
    HomePage.TAG: (_) => HomePage(),
    SessionsListPage.TAG: (_) => SessionsListPage(),
    NotesPage.TAG: (_) => NotesPage(),
    ProfilePage.TAG: (_) => ProfilePage(),
    LoginPage.TAG: (_) => LoginPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SKY Meditation',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: authService.authState,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done)
            return snapshot.hasData ? HomePage() : LoginPage();
          else
            return LoadingPage();
        },
      ),
      routes: _routes,
    );
  }
}

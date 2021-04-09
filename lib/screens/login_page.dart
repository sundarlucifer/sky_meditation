import 'package:sky_meditation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:sky_meditation/services/services.dart';

class LoginPage extends StatelessWidget {
  static const TAG = 'login-page';

  _signIn(context) {
    authService.signInWithGoogle().then((u) {
      if (u != null) Navigator.pushReplacementNamed(context, HomePage.TAG);
    });
  }

  @override
  Widget build(BuildContext context) {
    _signIn(context);
    return LoadingPage();
  }
}
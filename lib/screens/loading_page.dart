import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  static const TAG = 'login-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
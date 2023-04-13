import 'package:flutter/material.dart';
import 'package:jpj_hrm_mobile/screens/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    Key? key,
  }) : super(key: key);
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      child = const BottomNavScreen(
        selectedIdx: 0,
        selectedIdxAbsen: 0,
      );
    } else {
      child = Login();
    }

    return Scaffold(
      body: child,
    );
  }

  checkIfLoggedIn() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    dynamic token = session.getString('token');

    if (token != null) {
      isAuth = true;
      setState(() {});
    }
  }
}

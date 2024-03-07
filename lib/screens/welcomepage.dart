import 'dart:async';

import 'package:flutter/material.dart';
import 'package:eee/bottombar.dart';
import 'package:eee/screens/authentication/loginpage.dart';

import '../utils/data.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    initPage();
  }

  void initPage() async {
    bool isNotLogged = auth.currentUser == null;
    if (!isNotLogged) {
      var data =
          await ref.collection('users').doc('${auth.currentUser!.uid}').get();
      setState(() {
        userData = data;
      });
    }

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (builder) => isNotLogged ? LoginPage() : BottomBar()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green.withOpacity(0.4),
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            'Welcome to Department of Electrical and Electronic Engineering',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

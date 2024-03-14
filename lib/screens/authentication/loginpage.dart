import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eee/bottombar.dart';
import 'package:eee/screens/authentication/adminlogin.dart';
import 'package:eee/screens/authentication/registrationpage.dart';
import 'package:eee/utils/data.dart';
import 'package:eee/utils/methods.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('img/bg.png'), fit: BoxFit.cover),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 200, left: 15, right: 15),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.7),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppString.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                space(x: 30),
                Container(
                  color: Colors.white.withOpacity(.6),
                  child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      labelText: 'Email',
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                space(x: 15),
                Container(
                  color: Colors.white.withOpacity(.6),
                  child: TextField(
                    obscureText: true,
                    controller: password,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                space(x: 15),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await auth.signInWithEmailAndPassword(
                          email: email.text, password: password.text);
                      var data = await ref
                          .collection('users')
                          .doc('${auth.currentUser!.uid}')
                          .get();
                      setState(() {
                        userData = data;
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => BottomBar()),
                          (route) => false);
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    fixedSize: Size(MediaQuery.of(context).size.width, 50),
                  ),
                ),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      'Not an user?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => RegistrationPage()));
                        },
                        child: Text('Register')),
                    Spacer(),
                  ],
                ),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      'An Admin?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AdminLoginPage()));
                        },
                        child: Text('Admin Login')),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

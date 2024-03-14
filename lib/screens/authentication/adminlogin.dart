import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/data.dart';
import '../../utils/methods.dart';
import '../admin/dashboard.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
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
                  AppString.appName + ' Admin',
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
                    controller: password,
                    obscureText: true,
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
                      var role = data['role'];
                      if (role == UserRole.ADMIN) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => AdminDashboard()),
                            (r) => false);
                      } else {
                        Fluttertoast.showToast(msg: 'You are not an admin');
                      }
                    } catch (e) {
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    fixedSize: Size(MediaQuery.of(context).size.width, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

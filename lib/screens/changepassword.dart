import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/data.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController pass = TextEditingController();
  TextEditingController cnpass = TextEditingController();
  TextEditingController npass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            TextFormField(
              controller: pass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Old Password',
                hintText: 'Old Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: npass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                hintText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: cnpass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                hintText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: ElevatedButton(
        onPressed: () async {
          if (npass.text != cnpass.text) {
            Fluttertoast.showToast(msg: 'Passwords fo not match. Try again');
          } else {
            try {
              final user = await auth.currentUser!;
              final cred = EmailAuthProvider.credential(
                  email: user.email!, password: pass.text);

              user.reauthenticateWithCredential(cred).then((value) {
                user.updatePassword(npass.text).then((_) {
                  Fluttertoast.showToast(msg: 'Password changed successfully');
                  Navigator.pop(context);
                }).catchError((error) {
                  Fluttertoast.showToast(msg: error.toString());
                });
              });
            } catch (e) {
              Fluttertoast.showToast(msg: e.toString());
            }
          }
        },
        child: Text('Change Password'),
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width, 50),
          backgroundColor: Colors.green,
          shape: ContinuousRectangleBorder(),
        ),
      ),
    );
  }
}

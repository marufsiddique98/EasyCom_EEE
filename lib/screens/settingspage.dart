import 'package:eee/screens/authentication/loginpage.dart';
import 'package:eee/screens/changepassword.dart';
import 'package:eee/utils/data.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        titleSpacing: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            ListTile(
              title: Text('Delete Account'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text('Do you want to delete this account?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            auth.currentUser?.delete();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => LoginPage()),
                                (route) => false);
                          } catch (e) {
                            Fluttertoast.showToast(msg: e.toString());
                          }
                        },
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Change Password'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ChangePasswordPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

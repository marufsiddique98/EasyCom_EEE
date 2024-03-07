import 'package:flutter/material.dart';

import '../screens/authentication/loginpage.dart';
import 'data.dart';

SizedBox space({required double x, bool vertical = true}) {
  return vertical ? SizedBox(height: x) : SizedBox(width: x);
}

void showLoading(BuildContext context) {
  showAdaptiveDialog(
      context: context,
      builder: (_) => AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Center(child: CircularProgressIndicator()),
          ));
}

Drawer drawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: [
        DrawerHeader(
            child: CircleAvatar(
          radius: 45,
          backgroundImage: NetworkImage(auth.currentUser!.photoURL!),
        )),
        ListTile(
          title: Text('Logout'),
          onTap: () async {
            await auth.signOut();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false);
          },
        ),
      ],
    ),
  );
}

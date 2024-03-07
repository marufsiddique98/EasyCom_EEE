import 'package:eee/screens/admin/slider/list.dart';
import 'package:eee/screens/admin/userlist.dart';
import 'package:eee/screens/authentication/loginpage.dart';
import 'package:flutter/material.dart';

import '../../utils/data.dart';
import 'notice/list.dart';

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
          leading: Icon(Icons.notifications_active),
          title: Text('Notice'),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => NoticeListPage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.slideshow),
          title: Text('Sliders'),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => SliderListPage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Users'),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => AllUserList()));
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () async {
            await auth.signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                (route) => false);
          },
        ),
      ],
    ),
  );
}

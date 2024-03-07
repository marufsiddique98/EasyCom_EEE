import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eee/screens/chatlist.dart';
import 'package:eee/screens/homepage.dart';
import 'package:eee/screens/menupage.dart';
import 'package:eee/screens/searchpage.dart';
import 'package:eee/screens/userspage.dart';
import 'package:eee/utils/data.dart';
import 'package:eee/utils/methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int index = 0;
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(AppString.appName),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.green.withOpacity(.4),
        child: PageView(
          onPageChanged: (v) {
            setState(() {
              index = v;
            });
          },
          controller: controller,
          children: [
            HomePage(),
            UserListPage(),
            SearchPage(),
            MenuPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.greenAccent,
        currentIndex: index,
        onTap: (v) {
          setState(() {
            index = v;
            controller.jumpToPage(index);
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          final auth = FirebaseAuth.instance.currentUser;
          final chats =
              await FirebaseFirestore.instance.collection('chats').get();
          final allChats = chats.docs.map((doc) => doc.data()).toList();
          List<Map<String, dynamic>> selectedChats = [];
          for (Map<String, dynamic> c in allChats) {
            if (c['chatId'].contains('${auth?.uid}')) {
              selectedChats.add(c);
            }
          }
          final users = await FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: '${auth?.uid}')
              .get();
          final user = users.docs.map((doc) => doc.data()).toList();
          String self = auth!.uid;

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChatList(chats: selectedChats, self: self)));
        },
        child: Icon(Icons.chat),
      ),
    );
  }
}

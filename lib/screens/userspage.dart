import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eee/screens/singleuserpage.dart';
import 'package:eee/utils/data.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  int index = 0;
  List<String> tabs = [
    UserRole.USER,
    UserRole.TEACHER,
    UserRole.STAFF,
    UserRole.STUDENT,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.greenAccent.withOpacity(.8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            DefaultTabController(
              length: 4,
              child: TabBar(
                onTap: (v) {
                  setState(() {
                    index = v;
                  });
                },
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    text: 'All ' + UserRole.USER + 's',
                  ),
                  Tab(
                    text: UserRole.TEACHER,
                  ),
                  Tab(
                    text: UserRole.STAFF,
                  ),
                  Tab(
                    text: UserRole.STUDENT,
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: index == 0
                  ? ref.collection('users').snapshots()
                  : ref
                      .collection('users')
                      .where('role', isEqualTo: tabs[index])
                      .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  var users = snapshot.data.docs;
                  return GridView.builder(
                      padding: EdgeInsets.all(15),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: users.length,
                      itemBuilder: (_, i) {
                        var user = users[i];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        SingleUserPage(user: user)));
                          },
                          child: Card(
                            child: Column(
                              children: [
                                Flexible(
                                    child: CachedNetworkImage(
                                        imageUrl: user['avatar'])),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(user['name']),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
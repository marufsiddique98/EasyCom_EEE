import 'package:eee/screens/userspage.dart';
import 'package:flutter/material.dart';

class AllUserList extends StatefulWidget {
  const AllUserList({super.key});

  @override
  State<AllUserList> createState() => _AllUserListState();
}

class _AllUserListState extends State<AllUserList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('All Users'),
      ),
      body: UserListPage(),
    );
  }
}

import 'package:eee/screens/admin/utils.dart';
import 'package:flutter/material.dart';

import '../../utils/data.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        titleSpacing: 0,
      ),
      body: Container(
        child: GridView(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          children: [
            FutureBuilder(
              future: getAllUserCount(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        snapshot.data.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      Text(
                        'Total Users',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                );
              },
            ),
            FutureBuilder(
              future: getUserCount(UserRole.TEACHER),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        snapshot.data.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      Text(
                        'Teachers',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                );
              },
            ),
            FutureBuilder(
              future: getUserCount(UserRole.STUDENT),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        snapshot.data.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      Text(
                        'Students',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                );
              },
            ),
            FutureBuilder(
              future: getUserCount(UserRole.STAFF),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        snapshot.data.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      Text(
                        'Staffs',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<int> getAllUserCount() async {
    var data = await ref.collection('users').get();
    return data.docs.length;
  }

  Future<int> getUserCount(String role) async {
    var data =
        await ref.collection('users').where('role', isEqualTo: role).get();
    return data.docs.length;
  }
}

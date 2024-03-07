import 'package:flutter/material.dart';

class NoticeDetails extends StatelessWidget {
  final notice;
  const NoticeDetails({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                notice['name'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              Text(notice['desc']),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/data.dart';
import '../../noticedetails.dart';
import 'addnotice.dart';

class NoticeListPage extends StatefulWidget {
  const NoticeListPage({super.key});

  @override
  State<NoticeListPage> createState() => _NoticeListPageState();
}

class _NoticeListPageState extends State<NoticeListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Notices'),
        titleSpacing: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AddNoticePage()));
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ref.collection('notice').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            var data = snapshot.data.docs;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, i) {
                  var notice = data[i];

                  var subtitle = notice['desc'];
                  if (subtitle.length > 100) {
                    subtitle = notice['desc'].substring(0, 100) + '...';
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: GestureDetector(
                        onLongPress: () {
                          showAdaptiveDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text('Are you sure?'),
                                    content: Text(
                                        'Do you want to delete this item?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('No')),
                                      TextButton(
                                        onPressed: () async {
                                          await ref
                                              .collection('notice')
                                              .doc(notice['id'])
                                              .delete();
                                          Navigator.pop(context);
                                        },
                                        child: Text('Yes'),
                                      ),
                                    ],
                                  ));
                        },
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        NoticeDetails(notice: notice)));
                          },
                          title: Text(notice['name']),
                          subtitle: Text('$subtitle...'),
                        )),
                  );
                });
          }
        },
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/data.dart';
import 'addslider.dart';

class SliderListPage extends StatefulWidget {
  const SliderListPage({super.key});

  @override
  State<SliderListPage> createState() => _SliderListPageState();
}

class _SliderListPageState extends State<SliderListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Sliders'),
        titleSpacing: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AddSliderPage()));
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ref.collection('slider').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            var data = snapshot.data.docs;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, i) {
                  var slider = data[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: GestureDetector(
                      onLongPress: () {
                        showAdaptiveDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text('Are you sure?'),
                                  content:
                                      Text('Do you want to delete this item?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No')),
                                    TextButton(
                                      onPressed: () async {
                                        await ref
                                            .collection('slider')
                                            .doc(slider['id'])
                                            .delete();
                                        Navigator.pop(context);
                                      },
                                      child: Text('Yes'),
                                    ),
                                  ],
                                ));
                      },
                      child: AspectRatio(
                        aspectRatio: 7 / 3,
                        child: CachedNetworkImage(imageUrl: slider['imgurl']),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}

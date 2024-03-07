import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eee/screens/noticedetails.dart';
import 'package:eee/utils/methods.dart';

import '../utils/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 36.0,
                color: Colors.black,
                fontFamily: 'Canterbury',
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  ScaleAnimatedText('Welcome To'),
                  ScaleAnimatedText('Department of'),
                  ScaleAnimatedText('Electrical and'),
                  ScaleAnimatedText('Electronic Engineering'),
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: ref.collection('slider').snapshots(),
              builder: (_, snapshots) {
                if (!snapshots.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  var data = snapshots.data!.docs;
                  if (data.length == 0) return Container();
                  return CarouselSlider.builder(
                    options: CarouselOptions(
                      aspectRatio: 7 / 3,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: false,
                      enlargeFactor: 0.3,
                      scrollDirection: Axis.horizontal,
                    ),
                    itemCount: data.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(color: Colors.amber),
                        child: CachedNetworkImage(
                          imageUrl: data[index]['imgurl'],
                        ),
                      );
                    },
                  );
                }
              }),
          space(x: 15),
          Text(
            'Notices',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: ref.collection('notice').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                var notices = snapshot.data.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: notices.length,
                  itemBuilder: (_, i) {
                    var notice = notices[i];
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => NoticeDetails(notice: notice)));
                      },
                      title: Text(notice['name']),
                      subtitle: Text('${notice['desc'].substring(0, 100)}...'),
                    );
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }
}

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:eee/screens/singleuserpage.dart';
import 'package:eee/utils/methods.dart';

import '../utils/data.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Position position;
  bool loading = true;
  int index = 0;
  String img =
      'https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/man-person-icon.png';
  List<String> tabs = [
    'Alumni',
    '2018-19',
    '2019-20',
    '2020-21',
    '2021-22',
    '2022-23',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosition();
  }

  void getPosition() async {
    position = await determinePosition();
    setState(() {
      loading = false;
    });
  }

  String search = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  onChanged: (v) {
                    setState(() {
                      search = v;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: 'Search By Name',
                      prefixIcon: Icon(Icons.search)),
                ),
                space(x: 25),
                DefaultTabController(
                  length: 6,
                  child: TabBar(
                    isScrollable: true,
                    onTap: (v) {
                      setState(() {
                        index = v;
                      });
                    },
                    labelColor: Colors.black,
                    tabs: [
                      Tab(
                        text: 'Alumni',
                      ),
                      Tab(
                        text: '2018-19',
                      ),
                      Tab(
                        text: '2019-20',
                      ),
                      Tab(
                        text: '2020-21',
                      ),
                      Tab(
                        text: '2021-22',
                      ),
                      Tab(
                        text: '2022-23',
                      ),
                    ],
                  ),
                ),
                Text('Sorted By Distance:'),
                Expanded(
                  child: Container(
                    child: StreamBuilder(
                      stream: search == ''
                          ? ref
                              .collection('users')
                              .where('session', isEqualTo: tabs[index])
                              .snapshots()
                          : ref
                              .collection('users')
                              .where('name', isGreaterThanOrEqualTo: search)
                              .where('session', isEqualTo: tabs[index])
                              .snapshots(),
                      builder: (_, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else {
                          var documents = snapshot.data!.docs;
                          final users = documents.toList()
                            ..sort((a, b) => calculateDistance(
                                    a['position'][0], a['position'][1])
                                .compareTo(calculateDistance(
                                    b['position'][0], b['position'][1])));
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
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
                                              imageUrl: user['avatar'] == ''
                                                  ? img
                                                  : user['avatar'])),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(user['name']),
                                      ),
                                      Text(
                                          'Distance:${calculateDistance(user['position'][0], user['position'][1])}KM'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  String calculateDistance(lat1, lon1) {
    double lat2 = position.latitude;
    double lon2 = position.longitude;
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return (12742 * asin(sqrt(a)) / 1000).toStringAsFixed(3);
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}

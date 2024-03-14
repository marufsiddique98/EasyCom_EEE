import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:eee/screens/chatpage.dart';
import 'package:eee/utils/data.dart';
import 'package:eee/utils/methods.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class SingleUserPage extends StatefulWidget {
  final user;
  const SingleUserPage({super.key, required this.user});

  @override
  State<SingleUserPage> createState() => _SingleUserPageState();
}

class _SingleUserPageState extends State<SingleUserPage> {
  late final user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user['name']),
        titleSpacing: 0,
        actions: [
          // IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          ZegoSendCallInvitationButton(
            isVideoCall: false,
            iconSize: Size(40, 40),
            resourceID: "zegouikit_call",
            invitees: [
              ZegoUIKitUser(
                id: auth.currentUser!.uid,
                name: auth.currentUser!.displayName!,
              ),
              ZegoUIKitUser(
                id: user['uid'],
                name: user['name'],
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChatScreen(
                            uid: user['uid'],
                            name: user['name'],
                          )));
            },
            icon: Icon(Icons.chat),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: CachedNetworkImage(imageUrl: user['avatar'])),
                  Expanded(child: Container()),
                ],
              ),
              space(x: 15),
              Text('Name: ${user['name']}'),
              Text('Role: ${user['role']}'),
              Text(
                  'Birthday: ${DateTime.fromMillisecondsSinceEpoch(user['bday'].millisecondsSinceEpoch).toString().substring(0, 10)}'),
              Text('Gender: ${user['gender']}'),
              Text('Designation: ${user['designation']}'),
              Text('Address: ${user['address']}'),
              Row(
                children: [
                  Text('Phone Number:'),
                  Text('${user['phone']}'),
                  IconButton(
                    onPressed: () async {
                      try {
                        Fluttertoast.showToast(msg: 'Launching phone:');
                        await launchUrl(Uri.parse('tel:${user['phone']}'));
                      } catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    },
                    icon: Icon(
                      Icons.call,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Email Address:'),
                  Text('${user['email']}'),
                  IconButton(
                    onPressed: () async {
                      try {
                        Fluttertoast.showToast(msg: 'Launching email box:');
                        await launchUrl(Uri.parse('mailto:${user['email']}'));
                      } catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    },
                    icon: Icon(
                      Icons.email_outlined,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (_) => ViewUserLocationPage(
                  //             latitude: user['position'][0],
                  //             longitude: user['position'][1])));
                },
                child: Row(
                  children: [
                    Text('View Location'),
                    Icon(Icons.location_city),
                  ],
                ),
              ),
              FutureBuilder(
                future:
                    calculateDistance(user['position'][0], user['position'][1]),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    return Text(
                        'Distance From Me: ${(snapshot.data)?.toStringAsFixed(2)} meters or ${(snapshot.data! / 1000).toStringAsFixed(2)} Km');
                  }
                },
              ),
              // FutureBuilder(
              //   future: getLocation(user['position'][0], user['position'][1]),
              //   builder: (_, snapshot) {
              //     if (snapshot.hasError) {
              //       return Text(snapshot.error.toString());
              //     }
              //     if (!snapshot.hasData) {
              //       return Container();
              //     } else {
              //       return Text(snapshot.data!);
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<double> calculateDistance(lat1, lon1) async {
    Position position = await determinePosition();
    double lat2 = position.latitude;
    double lon2 = position.longitude;
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
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

  // Future<String> getLocation(double lat, double lng) async {
  //   String formattedAddress =
  //       await FlutterAddressFromLatLng().getFormattedAddress(
  //     latitude: lat,
  //     longitude: lng,
  //     googleApiKey: AppString.mapApiKey,
  //   );
  //   return formattedAddress;
  // }
}

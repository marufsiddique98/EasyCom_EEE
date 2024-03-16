import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:eee/bottombar.dart';
import 'package:eee/utils/methods.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../utils/data.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController(text: '');
  TextEditingController gender = TextEditingController(text: '');
  TextEditingController phone = TextEditingController(text: '');
  TextEditingController email = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');
  TextEditingController cpassword = TextEditingController(text: '');
  DateTime bday = DateTime.now();
  String session = '';
  TextEditingController dept = TextEditingController(text: 'EEE');
  TextEditingController role = TextEditingController(text: 'Student');
  TextEditingController desig = TextEditingController(text: '');
  TextEditingController sector = TextEditingController(text: '');
  TextEditingController address = TextEditingController(text: '');

  String imgurl = '', imgpath = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _determinePosition();
  }

  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value!)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Register',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? result =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (result != null) {
                      imgpath = result.path;
                      File file = File(result.path);

                      String id =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      Reference storageReference =
                          storage.ref().child('avatars/$id.jpg');

                      UploadTask uploadTask = storageReference.putFile(file);

                      await uploadTask.whenComplete(() async {
                        String url = await storageReference.getDownloadURL();
                        // await auth.currentUser?.updatePhotoURL(url);
                        setState(() {
                          imgurl = url;
                        });
                      });
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: imgurl == ''
                      ? CircleAvatar(
                          radius: 40,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(imgurl),
                          radius: 40,
                        ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: name,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateEmail,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validatePassword,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: cpassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validatePassword,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: phone,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gender'),
                          Container(
                            child: DropdownMenu<String>(
                              controller: gender,
                              dropdownMenuEntries: [
                                DropdownMenuEntry(value: 'Male', label: 'Male'),
                                DropdownMenuEntry(
                                    value: 'Female', label: 'Female'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Session'),
                          Container(
                            child: DropdownMenu<String>(
                              onSelected: (v) {
                                setState(() {
                                  session = v!;
                                });
                              },
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                    value: 'Alumni', label: 'Alumni'),
                                DropdownMenuEntry(
                                    value: '2018-19', label: '2018-19'),
                                DropdownMenuEntry(
                                    value: '2019-20', label: '2019-20'),
                                DropdownMenuEntry(
                                    value: '2020-21', label: '2020-21'),
                                DropdownMenuEntry(
                                    value: '2021-22', label: '2021-22'),
                                DropdownMenuEntry(
                                    value: '2022-23', label: '2022-23'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Department'),
                          Container(
                            child: DropdownMenu<String>(
                              controller: dept,
                              dropdownMenuEntries: [
                                DropdownMenuEntry(value: 'EEE', label: 'EEE'),
                                // DropdownMenuEntry(value: 'CSE', label: 'CSE'),
                                // DropdownMenuEntry(value: 'BME', label: 'BME'),
                                // DropdownMenuEntry(
                                //     value: 'ACCE', label: 'ACCE'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your Role:'),
                          Container(
                            child: DropdownMenu<String>(
                              onSelected: (v) {
                                setState(() {
                                  role.text = v!;
                                });
                              },
                              controller: role,
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                    value: UserRole.STUDENT,
                                    label: UserRole.STUDENT),
                                DropdownMenuEntry(
                                    value: UserRole.TEACHER,
                                    label: UserRole.TEACHER),
                                DropdownMenuEntry(
                                    value: UserRole.STAFF,
                                    label: UserRole.STAFF),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Text('Pick your birthday:'),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Birthday:'),
                          GestureDetector(
                              onTap: () async {
                                DateTime? date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now());
                                if (date != null) {
                                  setState(() {
                                    bday = date;
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  Text(bday.toString().substring(0, 10)),
                                  Icon(Icons.lock_clock)
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                if (role.text == UserRole.STAFF && session != 'Alumni')
                  TextFormField(
                    controller: desig,
                    decoration: InputDecoration(
                      labelText: 'Designation',
                      hintText: 'Designation',
                      border: OutlineInputBorder(),
                    ),
                  ),
                if (session == 'Alumni' && role.text != UserRole.TEACHER)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Text('Your Job Sector:')),
                      Expanded(
                        child: Container(
                          child: DropdownMenu<String>(
                            onSelected: (v) {
                              setState(() {
                                sector.text = v!;
                              });
                            },
                            controller: sector,
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                  value: 'Power Sector', label: 'Power Sector'),
                              DropdownMenuEntry(
                                  value: 'Communication Sector',
                                  label: 'Communication Sector'),
                              DropdownMenuEntry(
                                  value: 'Software Sector',
                                  label: 'Software Sector'),
                              DropdownMenuEntry(
                                  value: 'Business', label: 'Business'),
                              DropdownMenuEntry(
                                  value: 'Abroad Study', label: 'Abroad Study'),
                              DropdownMenuEntry(
                                  value: 'Abroad Settle',
                                  label: 'Abroad Settle'),
                              DropdownMenuEntry(
                                  value: 'Industrial Sector',
                                  label: 'Industrial Sector'),
                              DropdownMenuEntry(
                                  value: 'Teaching', label: 'Teaching'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 16.0),
                if (role.text == UserRole.TEACHER)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Text('Your Designation:')),
                      Expanded(
                        child: Container(
                          child: DropdownMenu<String>(
                            onSelected: (v) {
                              setState(() {
                                desig.text = v!;
                              });
                            },
                            controller: desig,
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                  value: 'Professor', label: 'Professor'),
                              DropdownMenuEntry(
                                  value: 'Associate Professor',
                                  label: 'Associate Professor'),
                              DropdownMenuEntry(
                                  value: 'Assistant Professor',
                                  label: 'Assistant Professor'),
                              DropdownMenuEntry(
                                  value: 'Lecturer', label: 'Lecturer'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: address,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () async {
                    showLoading(context);
                    // String imgurl =
                    //     'https://static-00.iconduck.com/assets.00/person-icon-476x512-hr6biidg.png';
                    if (password.text == cpassword.text) {
                      if (_formKey.currentState!.validate()) {
                        UserCredential user =
                            await auth.createUserWithEmailAndPassword(
                                email: email.text, password: password.text);
                        user.user?.updateDisplayName(name.text);
                        user.user?.updatePhotoURL(imgurl);
                        Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high);

                        if (role.text == UserRole.STUDENT) {
                          desig.text = UserRole.STUDENT;
                        }

                        await ref.collection('users').doc(user.user!.uid).set({
                          'id': Random().nextInt(90000) + 10000,
                          'uid': user.user!.uid,
                          'name': name.text,
                          'email': email.text,
                          'avatar': imgurl,
                          'imgpath': imgpath,
                          'phone': phone.text,
                          'bday': bday,
                          'designation': desig.text,
                          'role': role.text,
                          'gender': gender.text,
                          'dept': dept.text,
                          'session': session,
                          'sector': sector.text,
                          'address': address.text,
                          'position': [position.latitude, position.longitude],
                        });
                        var data = await ref
                            .collection('users')
                            .doc('${user.user!.uid}')
                            .get();
                        setState(() {
                          userData = data;
                        });
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => BottomBar()),
                            (route) => false);
                      }
                    } else {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: 'Paswords do not match. Try again!.');
                    }
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                      backgroundColor: Colors.greenAccent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
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

    return await Geolocator.getCurrentPosition();
  }
}

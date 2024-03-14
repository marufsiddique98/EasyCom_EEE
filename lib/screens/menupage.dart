import 'package:eee/screens/editprofilepage.dart';
import 'package:eee/screens/settingspage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../utils/data.dart';
import 'authentication/loginpage.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String imgurl = '', imgpath = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? result =
                    await picker.pickImage(source: ImageSource.gallery);

                if (result != null) {
                  imgpath = result.path;
                  File file = File(result.path!);

                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  Reference storageReference =
                      storage.ref().child('avatars/$id.jpg');

                  UploadTask uploadTask = storageReference.putFile(file);

                  await uploadTask.whenComplete(() async {
                    String url = await storageReference.getDownloadURL();
                    await auth.currentUser?.updatePhotoURL(url);
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
                      backgroundImage: NetworkImage(userData!['avatar']),
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(imgurl),
                      radius: 40,
                    ),
            ),
            Text(
              '${userData!['name']} (${userData!['dept']})',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text(
              userData!['email'],
              style: TextStyle(fontSize: 24),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SettingsPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.person_2),
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => EditProfilePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

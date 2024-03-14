import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/data.dart';
import '../utils/methods.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController desig = TextEditingController();
  TextEditingController role = TextEditingController();
  String session = '';
  TextEditingController address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
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
                controller: phone,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Column(
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
                        DropdownMenuEntry(value: 'Alumni', label: 'Alumni'),
                        DropdownMenuEntry(value: '2018-19', label: '2018-19'),
                        DropdownMenuEntry(value: '2019-20', label: '2019-20'),
                        DropdownMenuEntry(value: '2020-21', label: '2020-21'),
                        DropdownMenuEntry(value: '2021-22', label: '2021-22'),
                        DropdownMenuEntry(value: '2022-23', label: '2022-23'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              if (role.text != UserRole.STUDENT && session != 'Alumni')
                TextFormField(
                  controller: desig,
                  decoration: InputDecoration(
                    labelText: 'Designation',
                    hintText: 'Designation',
                    border: OutlineInputBorder(),
                  ),
                ),
              if (session == 'Alumni')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Your Job Sector:'),
                    Container(
                      child: DropdownMenu<String>(
                        controller: desig,
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
                              value: 'Abroad Settle', label: 'Abroad Settle'),
                          DropdownMenuEntry(
                              value: 'Industrial Sector',
                              label: 'Industrial Sector'),
                          DropdownMenuEntry(
                              value: 'Teaching', label: 'Teaching'),
                        ],
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
            ],
          ),
        ),
      ),
      bottomSheet: ElevatedButton(
        onPressed: () async {
          try {
            await ref.collection('users').doc(auth.currentUser!.uid).update({
              'name': name.text,
              'phone': phone.text,
              'designation': desig.text,
              'role': role.text,
              'session': session,
              'address': address.text,
            });
            Fluttertoast.showToast(msg: 'Profile Updated');
            Navigator.pop(context);
          } catch (e) {
            Fluttertoast.showToast(msg: e.toString());
          }
        },
        child: Text('Submit'),
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width, 50),
          backgroundColor: Colors.green,
          shape: ContinuousRectangleBorder(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/data.dart';

class AddNoticePage extends StatefulWidget {
  const AddNoticePage({super.key});

  @override
  State<AddNoticePage> createState() => _AddNoticePageState();
}

class _AddNoticePageState extends State<AddNoticePage> {
  TextEditingController name = TextEditingController();
  TextEditingController desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Add New Notice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            child: Column(
          children: [
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
              controller: desc,
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              minLines: 10,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        )),
      ),
      bottomSheet: ElevatedButton(
        onPressed: () async {
          try {
            String id = DateTime.now().millisecondsSinceEpoch.toString();
            await ref.collection('notice').doc('${id}').set({
              'uid': auth.currentUser!.uid,
              'id': id,
              'name': name.text,
              'desc': desc.text,
            });

            Fluttertoast.showToast(msg: 'Notice Saved Successfully');
            Navigator.pop(context);
          } catch (e) {
            Fluttertoast.showToast(msg: e.toString());
          }
        },
        child: Text(
          'Save',
          style: TextStyle(color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent,
          fixedSize: Size(MediaQuery.of(context).size.width, 50),
        ),
      ),
    );
  }
}

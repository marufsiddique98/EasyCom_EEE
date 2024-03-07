import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../utils/data.dart';

class AddSliderPage extends StatefulWidget {
  const AddSliderPage({super.key});

  @override
  State<AddSliderPage> createState() => _AddSliderPageState();
}

class _AddSliderPageState extends State<AddSliderPage> {
  String imgpath = '', imgurl = '';
  String id = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Add New Slider'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? result =
                await picker.pickImage(source: ImageSource.gallery);
            setState(() {
              id = DateTime.now().millisecondsSinceEpoch.toString();
            });
            if (result != null) {
              imgpath = result.path!;
              File file = File(result.path!);

              Reference storageReference =
                  storage.ref().child('sliders/$id.jpg');

              UploadTask uploadTask = storageReference.putFile(file!);
              // String url = await storageReference.getDownloadURL();

              await uploadTask.whenComplete(() async {
                String url = await storage
                    .ref()
                    .child('sliders/$id.jpg')
                    .getDownloadURL();
                setState(() {
                  imgurl = url;
                });
              });
            } else {
              // User canceled the picker
            }
          },
          child: AspectRatio(
            aspectRatio: 7 / 3,
            child: Container(
              decoration: imgurl == ''
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.greenAccent,
                    )
                  : BoxDecoration(
                      image: DecorationImage(image: NetworkImage(imgurl)),
                      borderRadius: BorderRadius.circular(10),
                    ),
              child: Center(
                child: Text('Upload Image'),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: ElevatedButton(
        onPressed: () async {
          try {
            if (imgurl == '' || imgpath == '') {
              Fluttertoast.showToast(msg: 'Invalid path or url');
            } else {
              id = DateTime.now().millisecondsSinceEpoch.toString();
              await ref.collection('slider').doc('${id}').set({
                'uid': auth.currentUser!.uid,
                'id': id,
                'imgpath': imgpath,
                'imgurl': imgurl,
              });
              setState(() {
                imgurl = '';
                imgpath = '';
              });
              Fluttertoast.showToast(msg: 'Notice Saved Successfully');

              Navigator.pop(context);
            }
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

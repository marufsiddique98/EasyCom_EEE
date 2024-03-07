import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import '../utils/data.dart';

class ChatScreen1 extends StatefulWidget {
  const ChatScreen1(
      {Key? key, required this.chat, required this.self, required this.worker})
      : super(key: key);
  final chat, self, worker;

  @override
  State<ChatScreen1> createState() => _ChatScreen1State();
}

class _ChatScreen1State extends State<ChatScreen1> {
  final ref = FirebaseFirestore.instance.collection('chats');
  String imageUrl = '';
  String imagePath = '';

  TextEditingController message = TextEditingController();
  double rating = 5.0;

  late final chat, self, worker;
  @override
  void initState() {
    super.initState();
    chat = widget.chat;
    self = widget.self;
    worker = widget.worker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(self == 'Seller' ? chat['sender'] : chat['user']),
        titleSpacing: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Flexible(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream:
                    ref.doc(chat['chatId']).collection('message').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_, i) {
                          DocumentSnapshot doc = snapshot.data!.docs[i];
                          return Row(
                            children: [
                              if (doc['sender'] == '${auth.currentUser!.uid}')
                                Expanded(child: Container()),
                              if (doc['type'] == 'text')
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: doc['sender'] !=
                                              '${auth.currentUser!.uid}'
                                          ? Colors.blue
                                          : Colors.purple,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      '${doc['message']}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              if (doc['type'] == 'image')
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: doc['sender'] !=
                                              '${auth.currentUser!.uid}'
                                          ? Colors.blue
                                          : Colors.purple,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: Flexible(
                                      child: Image.network('${doc['message']}'),
                                    ),
                                  ),
                                ),
                              if (doc['sender'] != '${auth.currentUser!.uid}')
                                Expanded(child: Container()),
                            ],
                          );
                        });
                  } else {
                    return Text("");
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? result =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (result == null)
                        return;
                      else {
                        String id =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        imagePath = result.path;
                        File file = File(result.path);

                        Reference storageReference =
                            storage.ref().child('sliders/$id.jpg');

                        UploadTask uploadTask = storageReference.putFile(file);

                        await uploadTask.whenComplete(() async {
                          String url = await storage
                              .ref()
                              .child('chats/$id.jpg')
                              .getDownloadURL();
                          setState(() {
                            imageUrl = url;
                          });
                        });
                      }

                      ref
                          .doc(chat['chatId'])
                          .collection('message')
                          .add({
                            'sender': '${auth.currentUser!.uid}',
                            'sender_name': '${auth.currentUser!.displayName}',
                            'message': imageUrl,
                            'type': 'image',
                            'time': DateTime.now(),
                          })
                          .then((value) => null)
                          .onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${error}')));
                          });
                    },
                    child: Icon(Icons.camera_alt),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: TextField(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    controller: message,
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      ref.doc(chat['chatId']).collection('message').add({
                        'sender': '${auth.currentUser!.uid}',
                        'sender_name': '${auth.currentUser!.displayName}',
                        'message': message.text,
                        'type': 'text',
                        'time': DateTime.now(),
                      }).then((value) {
                        message.text = '';
                      }).onError((error, stackTrace) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('${error}')));
                      });
                    },
                    child: Icon(Icons.send),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

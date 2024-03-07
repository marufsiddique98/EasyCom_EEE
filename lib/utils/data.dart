import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

late FirebaseFirestore ref;
late FirebaseAuth auth;
late FirebaseStorage storage;
DocumentSnapshot<Map<dynamic, dynamic>>? userData;

abstract class AppString {
  static const appName = 'EasyCom EEE';
  static const appId = 1945914872;
  static const appSign =
      '0b51ad005d720ccecf7aec7e3ed4413bc53070513d57aebfb7014fd69492bb1b';
  static const mapApiKey = 'AIzaSyDT3IO-_zRruI7FxP9XrVDQ8oEYAMlQjYY';
}

abstract class UserRole {
  static const USER = 'User';
  static const STUDENT = 'Student';
  static const ADMIN = 'Admin';
  static const STAFF = 'Staff';
  static const TEACHER = 'Teacher';
}

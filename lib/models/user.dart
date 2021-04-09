import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String displayName;
  String email;
  String photoUrl;
  DateTime lastSeen;

  static User from(DocumentSnapshot snapshot) {
    User user = User();
    user.uid = snapshot.documentID;
    user.displayName = snapshot['display_name'];
    user.email = snapshot['email'];
    user.photoUrl = snapshot['photo_url'];
    return user;
  }
}
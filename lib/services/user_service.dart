import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> getUsername(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc.data()?['username'];
    } else {
      return '';
    }
  }

  Future<String> getUserEmail(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc.data()?['email'];
    } else {
      return '';
    }
  }
}

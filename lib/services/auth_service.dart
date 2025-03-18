import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> registerUser(
      {required String email,
      required String password,
      required String username}) async {
    String res = "Error occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty && password.isNotEmpty) {
        UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        credential.user?.updateDisplayName(username);
        await firestore.collection("users").doc(credential.user!.uid).set({
          'username': username,
          'email': email,
          'uid': credential.user!.uid
        });
        res = 'credential.user!.uid';
      } else {
        res = 'Please do not leave any fields blank';
      }
    } catch (err) {
      return "Error: $err";
    }
    return res;
  }

  Future<String> signInUser(
      {required String email, required String password}) async {
    String res = "Error occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "Please enter both your e-mail and password";
      }
    } catch (e) {
      return "Error: $e";
    }
    return res;
  }
}

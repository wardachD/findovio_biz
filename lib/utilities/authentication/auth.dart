import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  //  final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<String?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      // This will create a new user in our firebase
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (ex) {
      return "${ex.code}: ${ex.message}";
    }
  }

  static Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (ex) {
      return "${ex.code}: ${ex.message}";
    }
  }
}

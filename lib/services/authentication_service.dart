import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<User?> signUpWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  UserCredential credential = await _auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

  return credential.user;
}

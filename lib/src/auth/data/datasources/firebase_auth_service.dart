import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signInAnonymously() async {
    final userCredential = await _auth.signInAnonymously();
    return userCredential.user?.uid ?? "";
  }
}

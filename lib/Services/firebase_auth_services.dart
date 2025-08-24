import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<User?> loginEmployee(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapErrorCode(e));
    }
  }

  
  Future<User?> registerEmployee(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        
        await _firestore.collection("employees").doc(user.uid).set({
          "id": user.uid,
          "email": email,
          "password": password,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapErrorCode(e));
    }
  }

  
  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  
  String _mapErrorCode(FirebaseAuthException e) {
    switch (e.code) {
      case "user-not-found":
        return "No user found with this email.";
      case "wrong-password":
        return "Incorrect password.";
      case "email-already-in-use":
        return "This email is already registered.";
      case "weak-password":
        return "Password is too weak.";
      default:
        return e.message ?? "Authentication failed.";
    }
  }
}

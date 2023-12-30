import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
User? myUser(Ref ref) {
  return FirebaseAuth.instance.currentUser;
}

bool get isAuthenticated {
  if (FirebaseAuth.instance.currentUser != null) {
    return true;
  }
  return false;
}
// User? myUser(User? ref)


// @riverpod
// User? myUser(User? ref) {
//   return FirebaseAuth.instance.currentUser;
// }

// @riverpod
// bool isAuthenticated(bool ref) {
//   if (typeofEquals(user, 'User')) {
//     return false;
//   }
//   return true;
// }

// signIn(AuthCredential credential) async {
//   await FirebaseAuth.instance.signInWithCredential(credential);
//   return user;
// }

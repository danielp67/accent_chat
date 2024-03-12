import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

enum AuthStatus {
  NotAuthenticated,
  Authenticating,
  Authenticated,
  UserNotFound,
  Error
}

class AuthProvider extends ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;
  AuthStatus status = AuthStatus.NotAuthenticated;
  late FirebaseAuth _auth;

  static AuthProvider instance = AuthProvider();

  AuthProvider() {
    _auth = FirebaseAuth.instance;
  }

  Future<void> loginUserWithEmailAndPassword(String email, String password)  async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user!;
      status = AuthStatus.Authenticated;
      print('logging successs');
    } catch (e) {
      status = AuthStatus.Error;
      print(e);
    }
    notifyListeners();
  }
}

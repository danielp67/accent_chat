import 'package:accent_chat/services/db_service.dart';

import '../services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../services/snackbar_service.dart';

enum AuthStatus {
  notAuthenticated,
  authenticating,
  authenticated,
  userNotFound,
  error
}

class AuthProvider extends ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;
  AuthStatus status = AuthStatus.notAuthenticated;
  late FirebaseAuth _auth;

  static AuthProvider instance = AuthProvider();

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _checkCurrentUserIsAuthenticated();
  }

  void _autoLogin() async {
    if(user != null){
      await DBService.instance.updateLastSeen(user!.uid);
      NavigationService.instance.navigateToReplacement('home');
    }
  }

  void _checkCurrentUserIsAuthenticated()async{
    user = _auth.currentUser;
    print(user);
    if(user != null){
      notifyListeners();
      _autoLogin();
    }
  }

  Future<void> loginUserWithEmailAndPassword(String email, String password)  async {
    status = AuthStatus.authenticating;
    notifyListeners();
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user!;
      status = AuthStatus.authenticated;
      SnackBarService.instance.showSnackBarSuccess('Connecté');
      await DBService.instance.updateLastSeen(user!.uid);
      NavigationService.instance.navigateToReplacement('home');
    } catch (e) {
      status = AuthStatus.error;
            print(e);
      user = null;
      SnackBarService.instance.showSnackBarError('Login failed, please retry');
    }
    notifyListeners();
  }

  void registerUserWithEmailAndPassword(String email, String password, Future<void> Function(String uid) onSucces)  async {
  status = AuthStatus.authenticating;
    notifyListeners();
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = result.user!;
      status = AuthStatus.authenticated;
           
      await onSucces(user!.uid);
      SnackBarService.instance.showSnackBarSuccess('Compte crée');
      NavigationService.instance.goBack();
      NavigationService.instance.navigateToReplacement('home');
    } catch (e) {
      status = AuthStatus.error;
            print(e);
      user = null;
      SnackBarService.instance.showSnackBarError('Creation failed, please retry');
    }
    notifyListeners();
  }


  void logoutUser(
    //Future<void> Function() onSucces
    ) async {
    status = AuthStatus.authenticating;
    notifyListeners();
    try {
      await _auth.signOut();
      user = null;
      status = AuthStatus.notAuthenticated;
      //await onSucces();
      await NavigationService.instance.navigateToReplacement('login');
      SnackBarService.instance.showSnackBarSuccess('Déconnecté');
      
    } catch (e) {
      status = AuthStatus.error;
      print(e);
      SnackBarService.instance.showSnackBarError('Erreur à la déconnexion');
    }
    notifyListeners();
  }



}

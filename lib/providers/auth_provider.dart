import 'package:accent_chat/services/db_service.dart';

import '../services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../services/snackbar_service.dart';

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
    _checkCurrentUserIsAuthenticated();
  }

  void _autoLogin() async {
    if(user != null){
      await DBService.instance.updateLastSeen(user!.uid);
      NavigationService.instance.navigateToReplacement('home');
    }
  }

  void _checkCurrentUserIsAuthenticated()async{
    user = await _auth.currentUser;
    if(user != null){
      notifyListeners();
      _autoLogin();
    }
  }

  Future<void> loginUserWithEmailAndPassword(String email, String password)  async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user!;
      status = AuthStatus.Authenticated;
      SnackBarService.instance.showSnackBarSuccess('Connecté');
      await DBService.instance.updateLastSeen(user!.uid);
      NavigationService.instance.navigateToReplacement('home');
    } catch (e) {
      status = AuthStatus.Error;
            print(e);
      user = null;
      SnackBarService.instance.showSnackBarError('Login failed, please retry');
    }
    notifyListeners();
  }

  void registerUserWithEmailAndPassword(String email, String password, Future<void> onSucces(String uid))  async {
  status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = result.user!;
      status = AuthStatus.Authenticated;
            print(result);
      await onSucces(user!.uid);
      SnackBarService.instance.showSnackBarSuccess('Compte crée');
      NavigationService.instance.goBack();
      NavigationService.instance.navigateToReplacement('home');
    } catch (e) {
      status = AuthStatus.Error;
            print(e);
      user = null;
      SnackBarService.instance.showSnackBarError('Creation failed, please retry');
    }
    notifyListeners();
  }


  void logoutUser(
    //Future<void> Function() onSucces
    ) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      await _auth.signOut();
      user = null;
      status = AuthStatus.NotAuthenticated;
      //await onSucces();
      await NavigationService.instance.navigateToReplacement('login');
      SnackBarService.instance.showSnackBarSuccess('Déconnecté');
      print('logouuut');
    } catch (e) {
      status = AuthStatus.Error;
      print(e);
      SnackBarService.instance.showSnackBarError('Erreur à la déconnexion');
    }
    notifyListeners();
  }



}

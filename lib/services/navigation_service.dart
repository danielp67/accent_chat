import 'package:flutter/material.dart';

class NavigationService {
  late GlobalKey<NavigatorState> navigatorKey;

  static NavigationService instance = NavigationService();

  NavigationService(){
    navigatorKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigateToReplacement(String routeName){
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

    Future<dynamic> navigateTo(String routeName){
    return navigatorKey.currentState!.pushNamed(routeName);
  }

    Future<dynamic> navigateToRoute(MaterialPageRoute route){
    return navigatorKey.currentState!.push(route);
  }

   void goBack(){
    return navigatorKey.currentState!.pop();
  }
}
import 'package:flutter/material.dart';

class SnackBarService{


  late BuildContext _buildContext;

  static SnackBarService instance = SnackBarService();

  SnackBarService(){}

   set buildContext(BuildContext context){
    _buildContext = context;
  }

  void showSnackBarError(String message){
   ScaffoldMessenger.of(_buildContext).showSnackBar(SnackBar(
        content: Text(
          message,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'ACTION',
          onPressed: () { },
        ),
          backgroundColor: Colors.red,
      ));
    }

      void showSnackBarSuccess(String message){
   ScaffoldMessenger.of(_buildContext).showSnackBar(SnackBar(
        content: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'ACTION',
          onPressed: () { },
        ),
        backgroundColor: Colors.green,

      ));
    }
  

}
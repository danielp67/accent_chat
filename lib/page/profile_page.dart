import 'package:accent_chat/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';
import '../providers/auth_provider.dart';
import '../services/navigation_service.dart';

class ProfilePage extends StatelessWidget{
 //ProfilePage({super.key, required this._height, required this._width});
  final double _height;
  final double _width;
  late AuthProvider _auth;
 
  ProfilePage(this._height, this._width, {super.key});

  @override
  Widget build(BuildContext context) {
  
    
    return Container(
        color: Theme.of(context).colorScheme.background,
        height: _height,
        width: _width,
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance, 
          child: _profilePageUI(),
          ),
    );
  
  }
  
  Widget _profilePageUI() {
    return Builder(
      builder: (BuildContext context) {
         _auth = Provider.of<AuthProvider>(context);

        return StreamBuilder<Contact>(
          stream: DBService.instance.getUserData(_auth.user?.uid),
          builder: (context, snapshot) {
            var userData = snapshot.data;
          
            return snapshot.hasData ? Align(
              child: SizedBox(
                height: _height * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[ 
                     _userImageWidget(userData!.image), 
                    _userNameWidget(userData!.name),
                    _userEmailWidget(userData!.email),
                    _logoutButton(),
                  ]
                ),
              ),
            ) : SpinKitWanderingCubes(
              color: Colors.blue,
              size: 50.0,
            );
          }
        );
      }
    );
  }

  Widget _userImageWidget(String _image) {
    double _imageRadius = _height * 0.20;
    return Container(
      height: _imageRadius,
      width: _imageRadius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_imageRadius),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(_image)
        )
      )
    );
  }


  Widget _userNameWidget(String userName) {
    return Container(
      height: _height * 0.05,
      width: _width,
      child: Text(
        userName,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30,
          color: Colors.white,
        )
      )
    );
  }
  
  Widget _userEmailWidget(String email) {
    return Container(
      height: _height * 0.03,
      width: _width,
      child: Text(
        email,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
        )
      )
    );
  }

  Widget _logoutButton() {
    return Container(
      height: _height * 0.06,
      width: _width * 0.8,
      child: MaterialButton(
        onPressed: () {
          _auth.logoutUser(
         // ()=>  NavigationService.instance.navigateToReplacement('login')
          
          );
        },
        color: Colors.red,
        child: const Text(
          "LOGOUT",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          )
        ),
      ) 
    );
  }
}
  
import 'dart:io';

import 'package:accent_chat/providers/auth_provider.dart';
import 'package:accent_chat/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/navigation_service.dart';
import '../services/media_service.dart';
import '../services/cloud_storage_service.dart';


class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late GlobalKey<FormState> _formKey;
  late AuthProvider auth;
  late String name;
  late String email;
  late String password;
  File? _image;

  _RegistrationPageState() {
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        alignment: Alignment.center,
        child: ChangeNotifierProvider<AuthProvider>.value(
            value: AuthProvider.instance, child: signupPageUI()),
      ),
    );
  }

  Widget signupPageUI() {
    return Builder(builder: (BuildContext context) {
      auth = Provider.of<AuthProvider>(context);
      return Container(
        height: _deviceHeight * 0.9,
        padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[_headingWidget(), _inputForm()],
        ),
      );
    });
  }

  Widget _headingWidget() {
    return Container(
      height: _deviceHeight * 0.2,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Let's get going !",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
          ),
          Text(
            "Please enter your details",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
          ),
        ],
      ),
    );
  }

  Widget _inputForm() {
    return Container(
      height: _deviceHeight * 0.55,
      child: Form(
        key: _formKey,
        onChanged: () {
          _formKey.currentState!.save();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _imageSelectorWidget(),
            _nameTextField(),
            _emailTextField(),
            _passwordTextField(),
            _registerButton(),
            _loginButton(),
          ],
        ),
      ),
    );
  }

  Widget _imageSelectorWidget() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          File? imageFile = await MediaService.instance.getImageFromLibrary();
print(imageFile);
          setState(() {
            _image = imageFile;
          });
        },
        child: Container(
          height: _deviceHeight * 0.10,
          width: _deviceHeight * 0.10,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(500),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: _image != null
                    ? FileImage(_image!) as ImageProvider
                    : const NetworkImage(
                        "https://cdn0.iconfinder.com/data/icons/occupation-002/64/programmer-programming-occupation-avatar-512.png")),
          ),
        ),
      ),
    );
  }

  Widget _nameTextField() {
    return TextFormField(
      autocorrect: false,
      style: const TextStyle(color: Colors.white),
      validator: (input) {
        return input!.isNotEmpty ? null : 'Enter valide name';
      },
      onSaved: (input) {
        setState(() {
          name = input!;
        });
      },
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: "Name",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      autocorrect: false,
      style: const TextStyle(color: Colors.white),
      validator: (input) {
        return input!.isNotEmpty && input.contains('@')
            ? null
            : 'Enter valide email';
      },
      onSaved: (input) {
        setState(() {
          email = input!;
        });
      },
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: "Email",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      autocorrect: false,
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      validator: (input) {
        return input!.isNotEmpty ? null : 'Enter valide password';
      },
      onSaved: (input) {
        setState(() {
          password = input!;
        });
      },
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: "Password",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return auth.status == AuthStatus.Authenticating ?
         const Center(child: CircularProgressIndicator()) :
        Container(
      height: _deviceHeight * 0.06,
      width: _deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.06,
        vertical: _deviceHeight * 0.0,
      ),
      child: MaterialButton(
        onPressed: () {
          if (_formKey.currentState!.validate() && _image != null) {
              auth.registerUserWithEmailAndPassword(email, password, (String uid) async {
                  var result = await CloudStorageService.instance.uploadUserImage(uid, _image!);
                  var imageURL = await result.ref.getDownloadURL();
                  await DBService.instance.createUserInDB(uid, name, email, imageURL);
              });
          }
        },
        color: Colors.blue,
        child: const Text(
          "REGISTER",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return GestureDetector(
      onTap: () {
        NavigationService.instance.goBack();
print('hemmo!');
      },
      child: Container(
        height: _deviceHeight * 0.06,
        width: _deviceWidth,
        child: const Text(
          "LOGIN",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

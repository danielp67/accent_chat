import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

   @override
  State<StatefulWidget> createState() {
   return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage>{
 late double _deviceHeight;
 late double _deviceWidth;


late GlobalKey<FormState> _formKey;

  _LoginPageState(){
    _formKey = GlobalKey<FormState>();
  }


  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
   return Scaffold(
    body: Align(
      alignment: Alignment.center,
      child: _loginPageUI(),
    ),
   );
  }

  Widget _loginPageUI(){
    return Container(
     // color: Colors.red,
      height: _deviceHeight * 0.60,
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.10
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
         _headingWidget(),
         _inputForm()
        ],
        ),
    );

  }

  Widget _headingWidget(){
    return Container(
      height: _deviceHeight * 0.12,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Welcome back !",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
          ),
          Text("Please login to your account :",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
          ),
        ],
        ),
    );
  }


  Widget _inputForm(){
  return Container(
    height: _deviceHeight * 0.25,
    child: Form(
      key: _formKey,
      onChanged: () {

      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _emailTextField(),
          _passwordTextField(),
          _loginButton(),
          _registerButton(),
        ],
      ),
      ),
  );
}

Widget _emailTextField(){
  return TextFormField(
    autocorrect: false,
    style: TextStyle(color: Colors.white),
    validator: (input) {},
    onSaved: (input) {},
    cursorColor: Colors.white,
    decoration: InputDecoration(
      hintText: "Email",
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        ),
    ),
  );
}

Widget _passwordTextField(){
  return TextFormField(
    autocorrect: false,
    obscureText: true,
    style: TextStyle(color: Colors.white),
    validator: (input) {},
    onSaved: (input) {},
    cursorColor: Colors.white,
    decoration: InputDecoration(
      hintText: "Password",
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        ),
    ),
  );
}


Widget _loginButton(){
  return Container(
    height: _deviceHeight * 0.06,
    width: _deviceWidth,
    padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.10,
        vertical: _deviceHeight * 0.0,
    ),
   child: MaterialButton(
    onPressed: () {},
    color: Colors.blue,
    child: Text("LOGIN",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      ),
    ),
  );
}


Widget _registerButton(){
  return GestureDetector(
    onTap: () {
      print('hemmo!');
    },
    child: Container(
        height: _deviceHeight * 0.06,
        width: _deviceWidth,
       child: Text("REGISTER",
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


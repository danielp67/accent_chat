import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState(){
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin{
  


  _ProfilePageState() {
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      body: const Text('Profile Page'),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
      
  }
}
  
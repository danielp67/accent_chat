import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/snackbar_service.dart';
import '../services/navigation_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  

  _HomePageState() {
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
     backgroundColor: Theme.of(context).colorScheme.background,
     appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: const Text('Accent Chat'),
      titleTextStyle: const TextStyle(fontSize: 16),
      ),
    );
  }

 
}

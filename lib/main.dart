import 'package:accent_chat/page/home_page.dart';
import 'package:accent_chat/page/registration_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './page/login_page.dart';
import './services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.instance.navigatorKey,
      title: 'Accent Chat',
      theme: ThemeData(
        brightness: Brightness.dark,
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      initialRoute: "login",
      routes: {
        "login": (BuildContext context) => const LoginPage(),
        "register": (BuildContext context) => const RegistrationPage(),
        "home": (BuildContext context) => const HomePage()
      },
      home: const RegistrationPage(),
    );
  }
}

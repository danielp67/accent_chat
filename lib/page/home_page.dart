import 'package:accent_chat/page/profile_page.dart';
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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
     backgroundColor: Theme.of(context).colorScheme.background,
     appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: const Text('Accent Chat'),
      titleTextStyle: const TextStyle(fontSize: 16),
      bottom: TabBar(
        indicatorColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        labelColor: Colors.blue,
        controller: _tabController,
        tabs: [
          Tab(
            icon: Icon(
              Icons.people_outline,
              size: 25,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.chat_bubble_outline,
              size: 25,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.person_outlined,
              size: 25,
            ),
          )
        ],
        ),
      ),
      body: _tabBarPages(),
    );
  }

 Widget _tabBarPages(){
  return TabBarView(
    controller: _tabController,
    children: <Widget>[
      ProfilePage(),
      ProfilePage(),
      ProfilePage(),
    ]);
 }
}

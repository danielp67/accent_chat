

import 'package:accent_chat/services/db_service.dart';
import 'package:accent_chat/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/contact.dart';
import '../providers/auth_provider.dart';
import 'conversation_page.dart';

class SearchPage extends StatefulWidget {
  final double _height;
  final double _width;

  const SearchPage(this._height, this._width, {super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

  class _SearchPageState extends State<SearchPage> {

      late String _searchName = "";
      late AuthProvider _auth;


      _SearchPageState();

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance, 
        child: _searchPageUI());
    }
    
     Widget _searchPageUI() {
      return Builder(
        builder: (context) {
          _auth = Provider.of<AuthProvider>(context);
          return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _userSearchField(),
                  _userListView(),
                ]
              );
            }
          );
        }
     

     Widget _userSearchField(){
      return Container(
        height: widget._height * 0.07,
        width: widget._width,
        padding: EdgeInsets.symmetric(
          vertical: widget._height * 0.02,
        ),
        child: TextField(
          autocorrect: false,
          style: const TextStyle(
             color: Colors.white,
          ),
          onSubmitted: (value) {
            setState(() {
              _searchName = value;

            });
          },
          decoration: const InputDecoration(
             prefixIcon: Icon(Icons.search, color: Colors.white),
             labelStyle: TextStyle(
                color: Colors.white
             ),
             labelText: 'Search',
             border: OutlineInputBorder(
              borderSide: BorderSide.none
             )
          )
        )
      );
     }

     Widget _userListView(){
      return StreamBuilder<List<Contact>>(
            stream: DBService.instance.getUsersInDB(_searchName),
            builder: (context, snapshot) {
              var usersData = snapshot.data;
            
              if(usersData != null){
                usersData.removeWhere(
                (element) => element.id == _auth.user?.uid
              );
              }
              
              return snapshot.hasData && usersData!= null ? SizedBox(
        height: widget._height * 0.7,
        child: ListView.builder(
          itemCount: usersData.length,
          itemBuilder: (context, index) {
            var userData = usersData[index];
            var currentDatetime = DateTime.now();
            var recipientId = userData.id;
            var isUserActive = userData.lastSeen.toDate()
            .isAfter(currentDatetime.subtract(const Duration(minutes: 10)));
            return ListTile(
              onTap: () {
                 DBService.instance.createOrGetConversation(
                  _auth.user!.uid,
                  recipientId,
                  (conversationID) {
                  return  NavigationService.instance.navigateToRoute(
                      MaterialPageRoute(
                        builder:
                      (context) => ConversationPage(conversationID,
                      recipientId, userData.image, userData.name)
                    ));
                  }
                  );       
              },
              title: Text(usersData[index].name),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(usersData[index].image)
                  )
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  isUserActive ?
                 const  Text('Active Now',
                  style: TextStyle(
                    fontSize: 15,
                  ))
                  : const Text('Last Seen',
                  style: TextStyle(
                    fontSize: 15,
                  )),
                  isUserActive ?
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(100),

                    )
                  ): 
                  Text(
                    timeago.format(userData.lastSeen.toDate()),
                    style: const TextStyle(fontSize: 15),
                  )
                ]

                ),
            );
          
          },
        ),

              ):
               const SpinKitWanderingCubes(
                color: Colors.blue,
                size: 50.0,
              );
            });
    }
  } 


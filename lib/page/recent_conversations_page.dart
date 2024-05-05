import 'package:accent_chat/page/conversation_page.dart';
import 'package:accent_chat/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/conversation.dart';
import '../models/message.dart';
import '../providers/auth_provider.dart';
import '../services/db_service.dart';

class RecentConversationsPage extends StatelessWidget {
  final double _height;
  final double _width;
  late AuthProvider _auth;

  RecentConversationsPage(this._height, this._width, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width,
      child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _conversationsListViewWidget(),
      )
    );
  }
  
  _conversationsListViewWidget() {
    return Builder(
       builder: (BuildContext context) {
         _auth = Provider.of<AuthProvider>(context);
         
        return StreamBuilder<List<ConversationSnippet>>(
          stream: DBService.instance.getUserConversation(_auth.user!.uid),
          builder: (context, snapshot) {
           var userData = snapshot.data;

            return userData != null ? Container(
              height: _height,
              width: _width,
              child: ListView.builder(
                itemCount: userData.length, 
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                       print(userData[index].messageType);
                      NavigationService.instance.navigateToRoute(
                        MaterialPageRoute(builder: (context) => 
                        ConversationPage(
                           userData[index].conversationID,
                           userData[index].id,
                           userData[index].image,
                           userData[index].name,
                        ),
                        ),
                      ); 
                      },
                    title: Text(userData[index].name),
                    subtitle: Text(
                       userData[index].messageType == MessageType.text ? 
                       userData[index].lastMessage : "Attachment : image"),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(userData![index].image),
                        ),
                      ),
                    ),
                    trailing: _listTileTrailingWidget(
                      userData[index].timestamp
                    ),
                  );
                }), 
            ) :
            userData != null ? const Center(
              child: Text('No Conversations')
              ) :  const SpinKitWanderingCubes(
              color: Colors.blue,
              size: 50.0,
            );
          }
        );
      }
    );
  }
  
  Widget _listTileTrailingWidget(Timestamp lastMessageTimestamp) {
    var timeDifference = lastMessageTimestamp.toDate().difference(DateTime.now());
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        const Text(
          "Last Message",
          style: TextStyle(fontSize: 15),
        ),
        Text(
          timeago.format(lastMessageTimestamp.toDate()),
          style: const TextStyle(fontSize: 15),
        ),
      ]
    );
  }

}
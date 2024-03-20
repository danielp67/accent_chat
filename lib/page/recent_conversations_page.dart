import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/conversation.dart';
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
            return userData != null && userData.length > 0 ? Container(
              height: _height,
              width: _width,
              child: ListView.builder(
                itemCount: userData.length, 
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                    
                    },
                    title: Text(userData[index].name),
                    subtitle: Text(userData[index].lastMessage),
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
            const SpinKitWanderingCubes(
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
        Text(
          timeago.format(lastMessageTimestamp.toDate()),
          style: const TextStyle(fontSize: 15),
        ),
        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            color: timeDifference.inHours > 1 ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(100),
          )
        )
      ]
    );
  }

}
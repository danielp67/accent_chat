
import 'package:accent_chat/models/conversation.dart';
import 'package:accent_chat/models/message.dart';
import 'package:accent_chat/services/db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../providers/auth_provider.dart';


class ConversationPage extends StatefulWidget {
  String conversationID;
  String receiverID;
  String receiverImage;
  String receiverName;

 
  ConversationPage(
      this.conversationID, this.receiverID, this.receiverImage, this.receiverName,
      {super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {

  late double _deviceHeight;
  late double _deviceWidth;

  late AuthProvider auth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(31, 31, 1, 1.0),
        title: Text(widget.receiverName),
      ),
      body: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _conversationPageUI(),
      )
    );
  }

  Widget _conversationPageUI() {
   return Builder(
     builder: (context) {
       auth = Provider.of<AuthProvider>(context);
       return Stack(
        clipBehavior: Clip.none,
         children: <Widget>[
           _messageListView(),
         ]
       );
     }
   ) ;
  }
  
  Widget _messageListView() {
    return Container(
      height: _deviceHeight * 0.8,
      width: _deviceWidth,
      child: StreamBuilder<Conversation>(
        stream: DBService.instance.getConversation(widget.conversationID),
        builder: (context, snapshot) {
          var conversationData = snapshot.data;
          return snapshot.hasData ? 
          ListView.builder(
            itemCount: conversationData!.messages.length,
            itemBuilder: (context, index) {
              var message = conversationData.messages[index];
              bool isSender = message["senderID"] == auth.user!.uid;
              return _messageListViewChild(isSender, message);
            }
          ):
          const SpinKitWanderingCubes(
            color: Color.fromRGBO(42, 117, 188, 1),
            size: 50.0,
          );
        }
      )
    );
  }
  

Widget _messageListViewChild(bool isSender,  message) {
  return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    !isSender ? _userImageWidget() : Container(),
                    _textMessageBubble(isSender , message["message"], message["timestamp"]),
                  ],
                ),
              );
}


Widget _userImageWidget(){
  double imageRadius = _deviceHeight * 0.05;
  return Container(
    height: imageRadius,
    width: imageRadius,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(
        image: NetworkImage(
          widget.receiverImage
        )
      )
    )
  );
}

  Widget _textMessageBubble(bool isSender, String text, Timestamp timestamp) {
    List<Color> colorScheme = isSender ? [
      Colors.blue,
     const Color.fromRGBO(42, 117, 188, 1),
    ] : [
     const Color.fromRGBO(69, 69, 69, 1),
      const Color.fromRGBO(43, 43, 43, 1),
    ];
    return Container(
      height: _deviceHeight * 0.1,
      width: _deviceWidth * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: colorScheme,
          stops: const [0.3, 0.7],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight
          ),

      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text
          ),
          Text(
            timeago.format(timestamp.toDate()), 
            style: const TextStyle(
              color: Colors.white70,
            )),
        ]
      ),
    );
  }
}

import 'dart:async';

import 'package:accent_chat/models/conversation.dart';
import 'package:accent_chat/models/message.dart';
import 'package:accent_chat/services/cloud_storage_service.dart';
import 'package:accent_chat/services/db_service.dart';
import 'package:accent_chat/services/media_service.dart';
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
  late GlobalKey<FormState> _formKey;
  late AuthProvider auth;
  late String messageText = "";
  final ScrollController _listViewController = ScrollController();
  

  _ConversationPageState(){
    _formKey =  GlobalKey<FormState>();
  }
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
           Align(
            alignment: Alignment.bottomCenter,
            child: _messageField(context)),
         ]
       );
     }
   ) ;
  }
  
  Widget _messageListView() {
    return Container(
      height: _deviceHeight * 0.9,
      width: _deviceWidth,
      child: StreamBuilder<Conversation>(
        stream: DBService.instance.getConversation(widget.conversationID),
        builder: (context, snapshot) {
          Timer(
            const Duration(milliseconds: 50), 
            () => 
            _listViewController.jumpTo(_listViewController.position.maxScrollExtent)
          );
          
          var conversationData = snapshot.data;
          return snapshot.hasData ? 
          ListView.builder(
            controller: _listViewController,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                  mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    !isSender ? _userImageWidget() : Container(),
                    SizedBox(width: _deviceWidth * 0.02),
                    message["type"] == "text" ?
                    _textMessageBubble(isSender , message["message"], message["timestamp"]) 
                    : _imageMessageBubble(isSender, message["message"], message["timestamp"])
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
      height: _deviceHeight * 0.08 + (text.length /20 * 5),
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

    Widget _imageMessageBubble(bool isSender, String imageURL, Timestamp timestamp) {
    List<Color> colorScheme = isSender ? [
      Colors.blue,
     const Color.fromRGBO(42, 117, 188, 1),
    ] : [
     const Color.fromRGBO(69, 69, 69, 1),
      const Color.fromRGBO(43, 43, 43, 1),
    ];
    DecorationImage image = DecorationImage(
      image: NetworkImage(
        imageURL
      ),
      fit: BoxFit.cover
    );
    return Container(
    //  height: _deviceHeight * 0.08 + (imageURL.length /20 * 5),
    //  width: _deviceWidth * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          Container(
            height: _deviceHeight * 0.3,
            width: _deviceWidth * 0.40,
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(15),
             image:  image
          )
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

  Widget _messageField(BuildContext context) {
    return Container(
      height: _deviceHeight * 0.1,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(43, 43, 43, 1),
        borderRadius: BorderRadius.circular(100)
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.01, 
        vertical: _deviceHeight * 0.02
        ),
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _messageTextField(),
            _sendButton(context),
            _imageMessageButton(),
          ],
        ),
      
      )
    ); 
  }


  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.6,
      child: TextFormField(
        validator: (value) {
          if(value!.isEmpty){
            return "Can't send empty message";
          }
          return null;
        },
        onChanged: (value) {
          _formKey.currentState!.save();
        },
        onSaved: (value) {
          setState(() {
            messageText = value!;
          });
        },
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          hintText: "Type a Message",
          border: InputBorder.none,
        ),
        autocorrect: false,
      ),
    );
}

  Widget _sendButton(BuildContext context) {
    return Container(
      height: _deviceHeight * 0.05,
      width: _deviceHeight * 0.05,
      child: IconButton(
        icon: const Icon(
          Icons.send,
          color: Colors.white,
        ),
        onPressed: () {
          if(_formKey.currentState!.validate()){
            DBService.instance.sendMessage(
              widget.conversationID, 
            Message(senderID: auth.user!.uid, text: messageText, timestamp: Timestamp.now(), messageType: MessageType.text));
            
          }
          _formKey.currentState!.reset();
          FocusScope.of(context).unfocus();
          
        }
      ),
    );
  }
  
  Widget _imageMessageButton() {
    return Container(
      height: _deviceHeight * 0.05,
      width: _deviceHeight * 0.05,
      child: FloatingActionButton(
        onPressed: ()async {
          var image = await MediaService.instance.getImageFromLibrary();
          if(image != null){
           var result =  await CloudStorageService.instance.uploadMediaMessage(auth.user!.uid, image);
           var imageURL = await result.ref.getDownloadURL();
           DBService.instance.sendMessage(
             widget.conversationID,
             Message(senderID: auth.user!.uid, text: imageURL, timestamp: Timestamp.now(), messageType: MessageType.image)
           );
          }

        },
child: const Icon(
          Icons.camera_enhance,
          color: Colors.white,
        ),
      ),
    );
  }
}

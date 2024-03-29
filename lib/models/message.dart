import 'package:accent_chat/models/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image }

class Message {
  String senderID;
  String text;
  Timestamp timestamp;
  MessageType messageType;

  Message({
    required this.senderID,
    required this.text,
    required this.timestamp,
    required this.messageType,
  });

}
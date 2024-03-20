import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationSnippet {
  final String id;
  final String conversationID;
  final String name;
  final String image;
  final String lastMessage;
  final int unseenCount;
  final Timestamp timestamp;

  ConversationSnippet({
    required this.id,
    required this.name,
    required this.conversationID,
    required this.image,
    required this.lastMessage,
    required this.unseenCount,
    required this.timestamp,
  });

  factory ConversationSnippet.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return ConversationSnippet(
      id: snapshot.id,
      name: data['name'],
      conversationID: data['conversationID'],
      image: data['image'],
      lastMessage: data['lastMessage'] ?? '',
      unseenCount: data['unseenCount'],
      timestamp: data['timestamp'],
    );
  }
}

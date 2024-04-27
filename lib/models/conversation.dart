import 'package:accent_chat/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationSnippet {
  final String id;
  final String conversationID;
  final String name;
  final String image;
  final MessageType messageType;
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
    required this.messageType
  });

  factory ConversationSnippet.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    var messageType = data['type'] == "text" ? MessageType.text : MessageType.image;
    print(messageType);
        print(data);

    return ConversationSnippet(
      id: snapshot.id,
      name: data['name'],
      conversationID: data['conversationID'],
      image: data['image'],
      lastMessage: data['lastMessage'] ?? '',
      unseenCount: data['unseenCount'],
      timestamp: data['timestamp'],
      messageType: messageType,
    );
  }
}

class Conversation {
  final String id;
  final List members;
  final List messages;
  final String ownerID;

  Conversation({
    required this.id,
    required this.members,
    required this.messages,
    required this.ownerID,
  });

  factory Conversation.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    List messages = data['messages'];
    if(messages.isNotEmpty){
      messages.map((e) {
        var messageType = e["type"] == "text" ? MessageType.text : MessageType.image;
        return Message(
          senderID: e["senderID"],
          text: e["message"],
          timestamp: e["timestamp"],
          messageType: messageType,
        );
      }).toList();
    }
    else
    {
      messages = [];
    }
    return Conversation(
      id: snapshot.id,
      members: data['members'],
      messages: messages,
      ownerID: data['ownerID'],
    );
  }

}

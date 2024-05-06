import 'package:accent_chat/models/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/contact.dart';
import '../models/message.dart';

class DBService {
  static DBService instance = DBService();
  late FirebaseFirestore db;

  DBService(){
    db = FirebaseFirestore.instance;
  }

String userCollection = "Users";
String conversationsCollection = "Conversations";
Future<void> createUserInDB(String uid, String name, String email, String imageURL ) async{
 try {
    return await db.collection(userCollection).doc(uid).set({
    "name" : name,
    "email": email,
    "image": imageURL,
    "lastSeen": DateTime.now()
  }
  );
 } catch (e) {
   print(e);
 }
 }


Future<void> updateLastSeen(String userID) {
 var ref = db.collection(userCollection).doc(userID);

  return ref.update({
    "lastSeen": DateTime.now()
  });
}

Future<void> sendMessage(String conversationID, Message message) {
  var ref = db
      .collection(conversationsCollection)
      .doc(conversationID);
  
  var messageType = "";
  switch (message.messageType) {
    case MessageType.text:
      messageType = "text";
      break;
    case MessageType.image:
      messageType = "image";
      
      break;
    default:
  }
  return ref.update({
    "messages": FieldValue.arrayUnion(
      [
        {
      "message": message.text,
      "senderID": message.senderID,
      "timestamp": message.timestamp,
      "type": messageType

    }
    ]
    )
  });
}


Future<void> createOrGetConversation(
  String currentId, 
String recipientId, 
 Future<void> Function(String) onSucces
) async {
  var ref = db.collection(conversationsCollection);
  var userConversationRef = db.collection(userCollection)
      .doc(currentId)
      .collection(conversationsCollection);
  try {
    var conversation = await userConversationRef.doc(recipientId).get();

    if (conversation.exists) {
      return onSucces(conversation.data()!["conversationID"]);
    }else {
      var conversationRef = ref.doc();
       await conversationRef.set({
        "members": [currentId, recipientId],
        "ownerID": currentId
      }); 
      return onSucces(conversationRef.id); 
     }
  } catch (e) {
    print(e);
    
    }

  }


Stream<Contact> getUserData(String? userID){
  var ref = db.collection(userCollection).doc(userID);
  return ref.get().asStream().map((snapshot){
    return Contact.fromFirestore(snapshot);
  });
  }



Stream<List<ConversationSnippet>> getUserConversation(String userID) {
  var ref = db
      .collection(userCollection)
      .doc(userID)
      .collection(conversationsCollection);
      
return ref.snapshots().map((snapshot) {
    return snapshot.docs.map((document) =>
    ConversationSnippet.fromFirestore(document)
    ).toList();
  });
}



Stream<List<Contact>> getUsersInDB(String searchName) {
  var ref = db
      .collection(userCollection)
      .where("name", isGreaterThanOrEqualTo: searchName)
      .where("name", isLessThan: '${searchName}z')
      ;
      
  return ref.get().asStream().map((snapshot) {
    return snapshot.docs.map((e) => 
       Contact.fromFirestore(e)
    ).toList();
  });
}


Stream<Conversation> getConversation(String conversationID) {
  var ref = db
      .collection(conversationsCollection)
      .doc(conversationID);
  return ref.snapshots().map((snapshot) {
    return Conversation.fromFirestore(snapshot);
  });
}

}

import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  static DBService instance = DBService();
  late FirebaseFirestore db;

  DBService(){
    db = FirebaseFirestore.instance;
  }

String userCollection = "Users";
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
}
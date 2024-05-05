import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService{
  static CloudStorageService instance = CloudStorageService();
  late FirebaseStorage storage;
  late Reference reference;
 String profileImages = "profile_images";
String messages = "messages";
 String images = "images";

 CloudStorageService(){
  storage = FirebaseStorage.instance;
  reference = storage.ref();
 }


Future<TaskSnapshot> uploadUserImage(String uid, File image )async {
  try {
    return await reference.child('$profileImages/$uid').putFile(image);
  } catch (e) {
    print(e);
    rethrow;
  }

}

Future<TaskSnapshot> uploadMediaMessage(String uid, File image )async {
  var timestamp = DateTime.now();
  var fileName = basename(image.path);
  try{
    return await reference
    .child(messages)
    .child(uid)
    .child(images)
    .child(fileName)
    .putFile(image)
    ;
  } catch(e){
    print(e);
    rethrow;

   }

}

}
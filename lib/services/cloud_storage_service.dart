import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService{
  static CloudStorageService instance = CloudStorageService();
  late FirebaseStorage storage;
  late Reference reference;
 String profileImages = "profile_images";

 CloudStorageService(){
  storage = FirebaseStorage.instance;
  reference = storage.ref();
 }


Future<TaskSnapshot> uploadUserImage(String uid, File image )async {
  try {
    print('uploadd');
    return await reference.child('$profileImages/$uid').putFile(image);
  } catch (e) {
    print(e);
    rethrow;
  }

}

}
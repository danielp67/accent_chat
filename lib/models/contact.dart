import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String id;
  String email;
  String image;
  String name;
  Timestamp lastSeen;

  Contact(
      {required this.id,
      required this.email,
      required this.image,
      required this.name,
      required this.lastSeen});

  factory Contact.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Contact(
      id: snapshot.id,
      email: data['email'], // Handle null values if necessary
      image: data['image'],
      name: data['name'],
      lastSeen: data['lastSeen'], // Provide a default value if necessary
    );
  }
}

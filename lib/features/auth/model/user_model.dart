import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel {
  final String uid;
  final String name;
  final String email;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  /// Convert model into a Map for writing to Firestore.
  Map<String, dynamic> toMap(){
    return{
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map){
    return UserModel(
      uid: map['uid'] as String, 
      name: map['name'] as String, 
      email: map['email'] as String, 
      createdAt: (map['createdAt'] as Timestamp).toDate()
    );
  }


}

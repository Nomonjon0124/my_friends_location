import 'package:cloud_firestore/cloud_firestore.dart';

class FriendModel {
  final String image;
  final double latitude;
  final double longitude;
  final String name;

  FriendModel({required this.image, required this.latitude, required this.longitude, required this.name});

  factory FriendModel.fromJson(int id, Map<String, dynamic> json) =>
      FriendModel(image: json['image'], latitude: json['latitude'], longitude: json['longitude'], name: json['name'],);

  Map<String, dynamic> toJson() => {'image': image, 'latitude': latitude, 'longitude': longitude, 'name': name,};

  factory FriendModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return FriendModel(image: data['image'], latitude: data['latitude'], longitude: data['longitude'], name: data['name']);
  }
}

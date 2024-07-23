import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_friends_location/data/model/friend_model.dart';
import 'package:my_friends_location/presentation/pages/map_screen.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Friends List",
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users1').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final friendsData = snapshot.data?.docs.map((doc) => FriendModel.fromFirestore(doc)).toList() ?? [];

          return ListView.builder(
              itemCount: friendsData.length,
              itemBuilder: (context, index) {
                var friend = friendsData[index];
                return itemFriend(context, friend);
              });
        },
      ),
    );
  }
}

Widget itemFriend(BuildContext context, FriendModel friend) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen(friendModel: friend)));
    },
    child: Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white12, width: 1.0),
          color: Theme.of(context).colorScheme.primary),
      child: Row(
        children: [
          Image.network(friend.image, width: 60, height: 60, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Center(
                child: Text(
              friend.name,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold, fontSize: 18),
            )),
          )
        ],
      ),
    ),
  );
}
